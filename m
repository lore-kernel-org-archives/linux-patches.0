Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F89145B3E;
	Thu, 11 Apr 2024 10:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830431; cv=none; b=Xw9jeqe+KpUiMbaJOTEu9MsG8NxtNuv/JLFoIpX4npptFBM19wtPb1t8ocu3X2QdQZQPbsHzdynCfo2tF9TQvjUMX8K7QbJVgk5eQxwI7yXfxFdIz12CZhIQcXb04nOPEw93YD14vTGy/iq7N70WfnjxiUIf7WnqR6N8aYimacc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830431; c=relaxed/simple;
	bh=YWX2S+HjNFw83l2qMWmYvU7adSh2VxY4GL45toYwhLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E7x8cD/RmE/ze0CTjER2N9kNDk5SVyW3fxQnHZLadogtqoA19weENKDG2qTQyQhaEQbTdEjYOp1CSygB0FzgTpja1JjNzj1tFbPMUWLYuIWXxsUlFyBtni3pa8CddFKKFSR+gZd1yoW9bLf5kbjVQhOLA51hmWOMXA1+fYFhxw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKKRXvOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKKRXvOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A139FC433F1;
	Thu, 11 Apr 2024 10:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830431;
	bh=YWX2S+HjNFw83l2qMWmYvU7adSh2VxY4GL45toYwhLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKKRXvOktIjPNSAnwq8FUD3ipXlDDrDZt8SDMMXVNBALYuppuokqJkHHs4dDJYwYV
	 wDoe0b8Zc1WMRnnUkyjHYgdnuv8lVPM831maeregy+FPzVcVwn+ss3x9gGZhnHNXT7
	 CLBEIr7FajeWA5OuJhmXHoF/9nu1BeR5f82O1s7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David McFarland <corngood@gmail.com>,
	Enrik Berkhan <Enrik.Berkhan@inka.de>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 136/143] platform/x86/intel/hid: Dont wake on 5-button releases
Date: Thu, 11 Apr 2024 11:56:44 +0200
Message-ID: <20240411095424.995498714@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David McFarland <corngood@gmail.com>

[ Upstream commit 5864e479ca4344f3a5df8074524da24c960f440b ]

If, for example, the power button is configured to suspend, holding it
and releasing it after the machine has suspended, will wake the machine.

Also on some machines, power button release events are sent during
hibernation, even if the button wasn't used to hibernate the machine.
This causes hibernation to be aborted.

Fixes: 0c4cae1bc00d ("PM: hibernate: Avoid missing wakeup events during hibernation")
Signed-off-by: David McFarland <corngood@gmail.com>
Tested-by: Enrik Berkhan <Enrik.Berkhan@inka.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/878r1tpd6u.fsf_-_@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 7457ca2b27a60..9ffbdc988fe50 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -504,6 +504,7 @@ static void notify_handler(acpi_handle handle, u32 event, void *context)
 	struct platform_device *device = context;
 	struct intel_hid_priv *priv = dev_get_drvdata(&device->dev);
 	unsigned long long ev_index;
+	struct key_entry *ke;
 	int err;
 
 	/*
@@ -545,11 +546,15 @@ static void notify_handler(acpi_handle handle, u32 event, void *context)
 		if (event == 0xc0 || !priv->array)
 			return;
 
-		if (!sparse_keymap_entry_from_scancode(priv->array, event)) {
+		ke = sparse_keymap_entry_from_scancode(priv->array, event);
+		if (!ke) {
 			dev_info(&device->dev, "unknown event 0x%x\n", event);
 			return;
 		}
 
+		if (ke->type == KE_IGNORE)
+			return;
+
 wakeup:
 		pm_wakeup_hard_event(&device->dev);
 
-- 
2.43.0



