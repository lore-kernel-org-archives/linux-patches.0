Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619356;
	b=Rx2W44gqcTU6u6L4uqGRIPntNtYL76fBgwfKOJgQ4SqB7FHIY6oAkjBmknbo/Am0gVkz
	 8/wEOrGgW0DbWdX5ODNERz9DIkkssPCI9Zs2wMvDx5N6MUMc2Ypqf6hL8rc9PupYoKScL
	 LVfRXTLUWUSiEqeu06hhhE8wTmDdAaxhdQOGV6WXaKXqZrCMyhfz2w6Pvof6vny33D6Ep
	 BLRP8H8CGyFOL9GX83U7gyqVBSgthI3gKspLrJ0CtL4TDiCX8Iqpr5TMfLpQwgn2yF2Pe
	 cS8+tDKt63kui6lfWyWi557nOYbvRZlP3sxNJc1s2dMjEL2grpC6TAOE7SPRZh3Huyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JL77zS4VNECsc7XkWOxsO3UGn9Er5K3Ll5YhWCQ/X4c=;
	b=uhFCMkPd57sMUmVJ+Ggq4xgum2F1S3zNbtaR/QP93pIoC2tr+KB/CXWfadphhNz7A2ks
	 fbhxtmMpy/4DZEqo8+IifE1rp8cRJsx9lK2LfvPjHZHG3wpDinOrRzAJHD5+YBs6VAhSe
	 ihOV/qsRwD+aveIpd5GrhAumtgGIBO49rW8Eehx6uGpVZZPT49a3hK5Fnprdiz6cmQ/Sf
	 DIY5i2V7bTVa+mXehTQLfHc1NK8V6UVF96MKSiXppq0I/ukWdVsXGnUqQIsHClMpA3rp+
	 xMHmwUhVHIdena8QCd0np5YvNIDEwNlJMcWqISmoGe8IRPzIen0zw0IZYAHkFffFY+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnayEiRB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09B6606A321;
	Wed, 25 Nov 2026 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnayEiRB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13A01F000C4;
	Wed, 25 Nov 2026 15:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619355;
	bh=JL77zS4VNECsc7XkWOxsO3UGn9Er5K3Ll5YhWCQ/X4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnayEiRBt8IvOyw8u/PDhVNL2u4bOi67vwH8bbxJ66tK0t6W32xFN526v8hUU+QKU
	 8IE/reNiGb+yoikG/q3JnsR2c75KTtsna3Q0PWx2xy7oV6MzRqKrpQXTbiaQQ8qkNL
	 EVFUjNCQ8CpY0aAUC9fLtX3KYfDaXdsjjMLAGMe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davison <andy@dvsn.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.3 0570/1005] ALSA: hda: Fix [codec] ID matching in patch files for IDs with bit 31 set
Date: Wed, 25 Nov 2026 15:31:48 +0100
Message-ID: <20261125143835.103245023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Davison <andy@dvsn.net>

commit fda103c1432f344e1cd548f346d157b1e67ee7c5 upstream.

parse_codec_mode() reads the vendor and subsystem IDs of a patch file's
[codec] line into an int, and skips the check when the value is zero or
negative, as documented. An ID with bit 31 set, such as SigmaTel's
0x8384xxxx or Intel's 0x8086xxxx, comes out negative, so it is taken as
a wildcard and the section is applied to every codec instead of the one
it names.

This was seen on an OpenPeak OpenFrame 2 with an IDT 92HD75B2X5
(0x111d7608). A patch file written for the STAC9202 (0x83847632) in the
related OpenFrame 1 was applied to it, swapping the headphone and
speaker pin configurations, so auto-mute never muted the speaker.

Read the IDs as long long, so real IDs are compared exactly. Values
written as negative numbers (e.g. -1) still act as wildcards, as
documented; a hex value such as 0xffffffff is now compared as written.

Tested on 6.18.60 on an OpenFrame 2, with a rebuilt snd-hda-codec and
the STAC9202 patch file: user_pin_configs stays empty for the IDT codec,
and the headphone and line-out pins are assigned as the BIOS sets them.
Not tested on a STAC9202 itself.

The bug was tracked down and this fix written with an AI coding
assistant (Claude Code, Claude Opus 5.5), which also ran the tests
above. I have reviewed the change and the tests.

Fixes: ef940b0403d4 ("ALSA: hda - Allow patching with any vendor/subsystem ids")
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Davison <andy@dvsn.net>
Link: https://patch.msgid.link/20261106175518.18629-1-andy@dvsn.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/common/sysfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/hda/common/sysfs.c
+++ b/sound/hda/common/sysfs.c
@@ -512,11 +512,12 @@ static inline int strmatch(const char *a
 static void parse_codec_mode(char *buf, struct hda_bus *bus,
 			     struct hda_codec **codecp)
 {
-	int vendorid, subid, caddr;
+	long long vendorid, subid;
+	int caddr;
 	struct hda_codec *codec;
 
 	*codecp = NULL;
-	if (sscanf(buf, "%i %i %i", &vendorid, &subid, &caddr) == 3) {
+	if (sscanf(buf, "%lli %lli %i", &vendorid, &subid, &caddr) == 3) {
 		list_for_each_codec(codec, bus) {
 			if ((vendorid <= 0 || codec->core.vendor_id == vendorid) &&
 			    (subid <= 0 || codec->core.subsystem_id == subid) &&


