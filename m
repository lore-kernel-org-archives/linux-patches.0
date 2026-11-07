Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064732;
	b=CrJGrDlGmd4x9JIaVSCe2Gm0eudOhB3ee5Obrl0PoYvJXK8eaAUDKkxn99/JklVPWsTH
	 LdD1XUGFTsC6u/0nsXpVVajDAD8KlsSA0r5ldz2iiruet2n4IokJTsbfjQvJVEfixEWLZ
	 ImzHETJ0u/g7C0O24PQqE65qINEb3MXo6pooWgEjQ7LWlM1poZ2pA/p7IP1EB+M4KvDPg
	 AWzZkVVMOWfyoDHXxGapUpzkZGOFjyQDUhUyMbF4EboLyyDMBlOXAwDM1OarAyUugfuz0
	 lKcfQCtmX48wq+wnl47Q8dPEyyRG3FvSS6gzwxf/zMSHSBxmIFdxmUuH3NEk2llRahQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=cPRIyqLKhWyDkhP/O7MFqu4nUJcFAY+pKC70hfi8SjA=;
	b=cP7WJKbOBapkY09M5en6LlykJFU9PPWaAA31qofSdDm3OVbFl5zVYMBfi6vs3PZ4P+hi
	 ul79sefzh27+GuW7vjgIA3/aRIDsssOj8kW+taB8hklHu5mGjI6W3qp4seyMwdapZORZj
	 YO21PnGGjGfDayr15GkgiXWw2RACyY3xrZswCMJs6TxeZt5bOpz8uEs0mkpvDv33lBn0L
	 Mz5B0DWRpAvEwWgq0u0249WlTj7eXWsPrzb/6RV6/ux3pp6hLTSYESyFele0cFatJml2G
	 rTeBrMT880fgp3FQPFWRgDz2kqfc0Umi+YUd/purBh5gzhWVfArZlA5uhGDhYft1tvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i7zKAoxo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8C6606A9C9;
	Sat,  7 Nov 2026 15:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i7zKAoxo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD9A1F008A4;
	Sat,  7 Nov 2026 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064732;
	bh=cPRIyqLKhWyDkhP/O7MFqu4nUJcFAY+pKC70hfi8SjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7zKAoxoFnDnUDZbq5BoMJE9W242OE6uvHnUUEoVOz/OniiPo7f3hT9RnOVu0wRFp
	 twzkcs2mJAVXjbqbeW3RyrWGx3ck2+NGItTZcT3FXPDhl9LLHWUXvDxQ3zjI51SAoV
	 +OePRjAAglW4sNkDTgnn2xRA8FeMvMGAN+MGEUg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Baigue <hugobaigue2004@gmail.com>,
	Ponali <ponali2k@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0670/1257] platform/x86: asus-wmi: fix unclear usage of bd->props.power
Date: Sat,  7 Nov 2026 08:49:26 -0500
Message-ID: <20261107134957.764215098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Benato <denis.benato@linux.dev>

[ Upstream commit fd83d81ddf058d487e6d6489b18094f068e66a59 ]

The bd->props.power is checked in parts of the driver correctly
comparing with BACKLIGHT_POWER_ON, while in others with a raw usage
of bd->props.power and !bd->props.power, moreover in certain checks
the logic has been inverted due to BACKLIGHT_POWER_ON being defined
as 0: fix both the wrong usage and the inconsistencies by using
proper comparisons.

Fixes: 130d29c5627c ("platform/x86: asus-wmi: adjust screenpad power/brightness handling")
Closes: https://lore.kernel.org/all/178362762638.911488.8564892548331679884@eldamar.lan/
Closes: https://lore.kernel.org/all/ea9c63d1-4776-49d5-9dc4-6c09498f99c9@linux.dev/
Tested-by: Hugo Baigue <hugobaigue2004@gmail.com>
Tested-by: Ponali <ponali2k@gmail.com>
Cc: stable@vger.kernel.org
Assisted-by: zcode:glm-5.3-flash
Signed-off-by: Denis Benato <denis.benato@linux.dev>
Link: https://patch.msgid.link/20260916143838.170950-2-denis.benato@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index daf8bd17e6380..10c8fcb075b2d 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -4532,7 +4532,8 @@ static int update_screenpad_bl_status(struct backlight_device *bd)
 	u32 ctrl_param = bd->props.brightness;
 	int err = 0;
 
-	if (bd->props.power) {
+	switch (bd->props.power) {
+	case BACKLIGHT_POWER_ON:
 		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_POWER, 1, NULL);
 		if (err < 0)
 			return err;
@@ -4540,12 +4541,17 @@ static int update_screenpad_bl_status(struct backlight_device *bd)
 		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_LIGHT, ctrl_param, NULL);
 		if (err < 0)
 			return err;
-	}
+		break;
 
-	if (!bd->props.power) {
+	case BACKLIGHT_POWER_OFF:
 		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_POWER, 0, NULL);
 		if (err < 0)
 			return err;
+		break;
+
+	default:
+		pr_warn("Invalid screenpad backlight power state: %d\n", bd->props.power);
+		return -EINVAL;
 	}
 
 	return err;
-- 
2.53.0



