Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA61313776F;
	Wed,  3 Jul 2024 11:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005440; cv=none; b=UT/70yaDHW/sjFgBhx0hOljSG50JllmimhbgB3AzOu11Kc7TBZBuKZWQuaN5eS4XT4lTBP/JKOK+olvPQkZp4TH+/ad/6o0pwexo2i6kDzcOqpwP3ID221hdQTvAACW2ZesT/5wlxAcL0Bv+S1B3j6CSS5/oZOeF7//ck7kulsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005440; c=relaxed/simple;
	bh=1ec9Uq3EhC9imaOp4QBA5QUkCoyNH8S1T+xw1b3NofI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMZkMKCJvcpwFxr3wA/CYeZYW/vOVixWkJl9vKMKs+QmSyU6PrekUciY6y5TGbF9xkeZIKsXwaL0nQ6MDikyZfzR1pCK9HAqP0g+IUTfB5N4PBpR2CkWVVBsiI5yFPF72u5X5ioDHBxSI88DKKSxNDx28feUqUoBjzWO8u6XJms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXVJDgCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXVJDgCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748D5C32781;
	Wed,  3 Jul 2024 11:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005439;
	bh=1ec9Uq3EhC9imaOp4QBA5QUkCoyNH8S1T+xw1b3NofI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXVJDgCYQa65q84N4W/abyDsJbO8tnenL/t6/fMDpsijyv95cFBrTlHQiyya7XeKI
	 OEc+MFtC2TVnWes6sNMymF886fVpBq3byktG6LGClun/OwBVmZMzKQoH0DPheAjTIz
	 S+rSk0jVk7jftVn5WE+iTOo7NiQS9FazhikQPOKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Min-Hua Chen <minhuadotchen@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/356] Bluetooth: btqca: use le32_to_cpu for ver.soc_id
Date: Wed,  3 Jul 2024 12:36:26 +0200
Message-ID: <20240703102914.988361398@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Min-Hua Chen <minhuadotchen@gmail.com>

[ Upstream commit 8153b738bc547878a017889d2b1cf8dd2de0e0c6 ]

Use le32_to_cpu for ver.soc_id to fix the following
sparse warning.

drivers/bluetooth/btqca.c:640:24: sparse: warning: restricted
__le32 degrades to integer

Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: cda0d6a198e2 ("Bluetooth: qca: fix info leak when fetching fw build id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index d4ae33a5f805e..b850b5de9f862 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -635,7 +635,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/%s", firmware_name);
 	else if (qca_is_wcn399x(soc_type)) {
-		if (ver.soc_id == QCA_WCN3991_SOC_ID) {
+		if (le32_to_cpu(ver.soc_id) == QCA_WCN3991_SOC_ID) {
 			snprintf(config.fwname, sizeof(config.fwname),
 				 "qca/crnv%02xu.bin", rom_ver);
 		} else {
-- 
2.43.0



