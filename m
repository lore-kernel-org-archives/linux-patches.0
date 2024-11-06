Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FD71F428D;
	Wed,  6 Nov 2024 12:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897527; cv=none; b=sGOOUtqX0dFyiZRvFIl8fRDQLokklkJcHrtbrecmejqWljLlqVu3DPrKTcSE6muENGSL1QxCJK3S9tGzTVnSE/DWLZLVK8w8kXshTx621TjYWM0l2ju2PIv2LAW2/CRTKZYLoyjHFCbP5aA3ZkFZPfvhbrdDMYRQhT8hvzRrGrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897527; c=relaxed/simple;
	bh=ISIuu03VBuvaijttqByDt2g2VnA8d5faw1UnvsZVdM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqLshNX7CiB5B6czoU8r47CLhaY7yjcg2Gh2fsPpY5cA53zbnRWD5bTB8YISRglrHZL/F3H16XNvh23z5+HcRW3f0Mx1MWcgdZBpMK/zNcxYoyYF5LJNamChlfGmc1eUoHcIFEfoJQv3uGzlJgOo2sm1WUnKwtzORxnS9baFQk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=az9tN0cB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="az9tN0cB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCF6C4CECD;
	Wed,  6 Nov 2024 12:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897527;
	bh=ISIuu03VBuvaijttqByDt2g2VnA8d5faw1UnvsZVdM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=az9tN0cBMGUlSMzmzDQOWx7C6dKu5M8zKQ3CrosHQWZ536ioDkjMVY/eRSmIFHaLK
	 1S0HJnxcUwcmAfqo3FTeKiN97vkURkBPqAJ6KA7C2lKUvFfwtmrl0ykfTNcmPW+p0M
	 ybLEHA2i9mNByt+3xS4trtnEWchkNgW2ZSG/PEoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 084/151] usb: typec: qcom-pmic-typec: use fwnode_handle_put() to release fwnodes
Date: Wed,  6 Nov 2024 13:04:32 +0100
Message-ID: <20241106120311.175905629@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -268,7 +268,7 @@ static int qcom_pmic_typec_probe(struct
 	return 0;
 
 fwnode_remove:
-	fwnode_remove_software_node(tcpm->tcpc.fwnode);
+	fwnode_handle_put(tcpm->tcpc.fwnode);
 
 	return ret;
 }
@@ -280,7 +280,7 @@ static void qcom_pmic_typec_remove(struc
 	qcom_pmic_typec_pdphy_stop(tcpm->pmic_typec_pdphy);
 	qcom_pmic_typec_port_stop(tcpm->pmic_typec_port);
 	tcpm_unregister_port(tcpm->tcpm_port);
-	fwnode_remove_software_node(tcpm->tcpc.fwnode);
+	fwnode_handle_put(tcpm->tcpc.fwnode);
 }
 
 static struct pmic_typec_pdphy_resources pm8150b_pdphy_res = {


