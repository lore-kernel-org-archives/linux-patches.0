Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F98F184549;
	Tue, 30 Jul 2024 16:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358601; cv=none; b=hUp+HV5+pD7tUTMDtejAL023de42E70jrf/EIdLZrO80CDisS3Nm0PXuee19x/71SNZfaaIZJTGtJl348/jew1rI3wbgicjPhYRtC7UD1bxJWtVXLT+R7Otd81ke8k4D3XOssdbMsjPuw+j44LwvX6ohkVjb7Om4nckuY+g1qh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358601; c=relaxed/simple;
	bh=HvllZ+pJQ+1UfBQEoIrU7FoNIEVc4HQFTLMeNgNYnhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dg1UfBrlyaNk7RzH6KcVw5vNt0cmC6pNR9DyH37v+TxbUO6STBo7GTweJ3gXN9AGaCO/XhRNDbgyY5pSTt3dp6u1AeGCpbdKGIhroX/iapaRwmqunteinO4/wmxae6MN3Q+uV4MyDQETTqNeqvFiXEpLwkXYPzAWwHzvP+fJaso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K10ltQCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K10ltQCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B314C32782;
	Tue, 30 Jul 2024 16:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358601;
	bh=HvllZ+pJQ+1UfBQEoIrU7FoNIEVc4HQFTLMeNgNYnhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K10ltQCh5zMYFEySEQ/gZZ40QFSReXXjejtlyORV13oSn/nC86yWCLp/T/nxRYV20
	 dtWVkwTuCGePwuM+WQWjPiEYZEkZYLn77h2KvPrlL3o5O2k8W6sceMKpPZWhgKENvJ
	 meZzhppkHeSHKgpnXzjv8c7S/hoZuM2vMdMeJF8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <benato.denis96@gmail.com>,
	"Luke D. Jones" <luke@ljones.dev>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 377/809] platform/x86: asus-wmi: fix TUF laptop RGB variant
Date: Tue, 30 Jul 2024 17:44:13 +0200
Message-ID: <20240730151739.552097065@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit d8b17a364ec48239fccb65efe74bb485e79e6743 ]

In kbd_rgb_mode_store the dev_get_drvdata() call was assuming the device
data was asus_wmi when it was actually led_classdev.

This patch corrects this by making the correct chain of calls to get the
asus_wmi driver data.

Fixes: ae834a549ec1 ("platform/x86: asus-wmi: add support variant of TUF RGB")
Tested-by: Denis Benato <benato.denis96@gmail.com>
Signed-off-by: Luke D. Jones <luke@ljones.dev>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240716011130.17464-2-luke@ljones.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 3f9b6285c9a66..bc9c5db383244 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -879,10 +879,14 @@ static ssize_t kbd_rgb_mode_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
-	struct asus_wmi *asus = dev_get_drvdata(dev);
 	u32 cmd, mode, r, g, b, speed;
+	struct led_classdev *led;
+	struct asus_wmi *asus;
 	int err;
 
+	led = dev_get_drvdata(dev);
+	asus = container_of(led, struct asus_wmi, kbd_led);
+
 	if (sscanf(buf, "%d %d %d %d %d %d", &cmd, &mode, &r, &g, &b, &speed) != 6)
 		return -EINVAL;
 
-- 
2.43.0



