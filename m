Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6210A46D56D;
	Tue, 21 Jul 2026 20:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664433; cv=none; b=aTPIYXgu1V38hroIsfazsE6iRdCeIO4nbmvsigEVrCprmHe2nC1pHY8i4iwOAkNA15sjDlLZtGmn5XJK+Okmu1vlHrKM3bSBl37/TYhzHsFjfUNKnBJRhfP/ZbrtAsQ2EIjzc8T3OWOU36rCMUJYw5ZXzayaKYhu0YarAORoggA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664433; c=relaxed/simple;
	bh=z2yW4tbr9LF0No12kvAfTX3XZk3/fiJXELL0uK7bJb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A1Qv4Bc1mmfUP6qXGxLeB+qyjwnd1bC/Xaa54vFx1Z5ve/PMiyvq225vQlKiIqtPxNkwYG4VEx/52/nt1S8yBHd4dDOks7lAdVrt8yfcbtZXC+SXbzjgSfmO2xS/CD4MdyamL4WYhOM56dRfF89GaLgztvJ12UwILIsSWM0xMos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJ/WhsLD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJ/WhsLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67401F000E9;
	Tue, 21 Jul 2026 20:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664432;
	bh=ThoumGugZPazSw7sw0RKvoL12rwwS/e41bMgK/eHjmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJ/WhsLDycVtf+7nh59P7RDGg4m3f74Dqi24tv9gdWD+RGRjQjSdywxqOdWXt6Grj
	 9Q7zQucK0Cg50sPKkYDs7XKR4XLzYIQ5l5clZq5dQRsNjLMke9a/rcAQ8oVGYFKonO
	 w8BL0muThPIRKEpEv5jpF/NO8ZknMOccgYbJm2uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1196/1276] HID: pidff: Fix missing blank lines after declarations
Date: Tue, 21 Jul 2026 17:27:19 +0200
Message-ID: <20260721152512.820917699@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 42a2bd61650f13605f9283b5a9e6b1a26b7d4ec2 ]

Fixes chackpatch.pl warnings

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: b251598b8bf3 ("HID: pidff: Use correct effect type in effect update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-pidff.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -249,8 +249,8 @@ static u32 pidff_rescale_time(u16 time,
 {
 	u32 scaled_time = time;
 	int exponent = field->unit_exponent;
-	pr_debug("time field exponent: %d\n", exponent);
 
+	pr_debug("time field exponent: %d\n", exponent);
 	for (;exponent < FF_TIME_EXPONENT; exponent++)
 		scaled_time *= 10;
 	for (;exponent > FF_TIME_EXPONENT; exponent--)
@@ -354,6 +354,7 @@ static int pidff_needs_set_envelope(stru
 				    struct ff_envelope *old)
 {
 	bool needs_new_envelope;
+
 	needs_new_envelope = envelope->attack_level  != 0 ||
 			     envelope->fade_level    != 0 ||
 			     envelope->attack_length != 0 ||
@@ -733,6 +734,7 @@ static void pidff_playback_pid(struct pi
 static int pidff_playback(struct input_dev *dev, int effect_id, int value)
 {
 	struct pidff_device *pidff = dev->ff->private;
+
 	pidff_playback_pid(pidff, pidff->pid_id[effect_id], value);
 	return 0;
 }
@@ -1233,6 +1235,7 @@ static int pidff_find_effects(struct pid
 
 	for (i = 0; i < sizeof(pidff_effect_types); i++) {
 		int pidff_type = pidff->type_id[i];
+
 		if (pidff->set_effect_type->usage[pidff_type].hid !=
 		    pidff->create_new_effect_type->usage[pidff_type].hid) {
 			hid_err(pidff->hid,


