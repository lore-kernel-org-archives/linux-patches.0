Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62EA1D2784;
	Wed,  6 Nov 2024 12:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896167; cv=none; b=leKnKJPs0sEclgc5QouFUZQZRgfkHjsX/syTGx0/35gDhQqQHlDyV+/LnQ5jTWDvya8NItmZ3164/RTfja/9Rb0HdMDpk8lMK7BTmNgeSa0Yd9Etl5I6MaaTQv1xiU1Os8cpB24zr6AKYcsM8myH7+HgGxSkJLu82sqQcAbomDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896167; c=relaxed/simple;
	bh=oYBBvyyGeftF4dB5kmRL/txaEglNWt7xWMQ8LUxRhcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sw5uyaNYqc5y/4KW+olu8ytjBAawGYPCU96qkqoUar/GGnPiaGyWIQtuBPJ35dwMG3QAMBoU7iTWJCy92Oal2ZYoKInXjj7TWsGP68LH62yg97aitTFPBzSgV2Oafze/ljnMNxywGxKpOiTI0wBQiwDCJstP5HzHo9yZuoI7sDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OpmFX5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OpmFX5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C517C4CECD;
	Wed,  6 Nov 2024 12:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896167;
	bh=oYBBvyyGeftF4dB5kmRL/txaEglNWt7xWMQ8LUxRhcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2OpmFX5b6atKwtUV584a/9S1l7aQft2RHSTYgOF5tLEoeyfg2MmLtfsXYlowpezxs
	 vcFk5l+evBIooP4TL0lzjixP2z85kEGuuTpogYLuljpkNKkBXESc7tE+WTviUEKq2n
	 Qmz6NSmTdKDWlhTgLCO8UtqqGKWfQpFdrcIBtkE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.11 111/245] usb: typec: qcom-pmic-typec: use fwnode_handle_put() to release fwnodes
Date: Wed,  6 Nov 2024 13:02:44 +0100
Message-ID: <20241106120321.950813642@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 7f02b8a5b602098f2901166e7e4d583acaed872a upstream.

The right function to release a fwnode acquired via
device_get_named_child_node() is fwnode_handle_put(), and not
fwnode_remove_software_node(), as no software node is being handled.

Replace the calls to fwnode_remove_software_node() with
fwnode_handle_put() in qcom_pmic_typec_probe() and
qcom_pmic_typec_remove().

Cc: stable@vger.kernel.org
Fixes: a4422ff22142 ("usb: typec: qcom: Add Qualcomm PMIC Type-C driver")
Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Acked-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241020-qcom_pmic_typec-fwnode_remove-v2-1-7054f3d2e215@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec.c
+++ b/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec.c
@@ -123,7 +123,7 @@ port_stop:
 port_unregister:
 	tcpm_unregister_port(tcpm->tcpm_port);
 fwnode_remove:
-	fwnode_remove_software_node(tcpm->tcpc.fwnode);
+	fwnode_handle_put(tcpm->tcpc.fwnode);
 
 	return ret;
 }
@@ -135,7 +135,7 @@ static void qcom_pmic_typec_remove(struc
 	tcpm->pdphy_stop(tcpm);
 	tcpm->port_stop(tcpm);
 	tcpm_unregister_port(tcpm->tcpm_port);
-	fwnode_remove_software_node(tcpm->tcpc.fwnode);
+	fwnode_handle_put(tcpm->tcpc.fwnode);
 }
 
 static const struct pmic_typec_resources pm8150b_typec_res = {


