Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B301C302C;
	Mon, 14 Oct 2024 15:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919189; cv=none; b=IkElbql6zAeiG24dcwE7ZX/ozVcs+Pzs5jX3wnijARzXA3S+NNobqH7hBWjE3qxUCOL5JDZ65aW7klDPiz4np9U5ruKYvy7+Z5RaDoHqMbFEo45Z1GjmPma0M2FmDXAdUnFKzGIKsJmO7n8pxmSc2r21GtkXALBtbpt0fFX0PiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919189; c=relaxed/simple;
	bh=+SnORn+WSZtET3FMMemkf01V0f6UiT23Xe0yFhjGras=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bD0QZpOpKgUoJq0ayzSbpCNbPYjU4YXGtoahfbCCGRWDgFvN/ldH+VHHLpJRsulYXrwt5eqds4rcgj7MMaxpwjARqn80Xf0L5Zy/Cl7nijSCG9o0h1zenrU+fN9/KuZurzHfnFFmxegwkeXmQQQP4gNcs9zjv8zoZXBFbprEwVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1QCuE4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1QCuE4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49699C4CEC3;
	Mon, 14 Oct 2024 15:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919188;
	bh=+SnORn+WSZtET3FMMemkf01V0f6UiT23Xe0yFhjGras=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1QCuE4L0o6Bh+1rawQMjGWgYC/mCU+mDvEdRMQ8iGsHVklscmRtWGTR4KtQU06hG
	 uLSafjCh22bPgvE3kZA5nIUDVxUf3l3fyxOY9NBjMfanMiVfAkKiw6UBBi5q3m3RAt
	 t2PNV97eCfXZT57YYOWtprd7EmG59ASvH9bqWL1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Hans P. Moller" <hmoller@uc.cl>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 538/798] ALSA: line6: add hw monitor volume control to POD HD500X
Date: Mon, 14 Oct 2024 16:18:12 +0200
Message-ID: <20241014141239.135717522@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans P. Moller <hmoller@uc.cl>

commit 703235a244e533652346844cfa42623afb36eed1 upstream.

Add hw monitor volume control for POD HD500X. This is done adding
LINE6_CAP_HWMON_CTL to the capabilities

Signed-off-by: Hans P. Moller <hmoller@uc.cl>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241003232828.5819-1-hmoller@uc.cl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/line6/podhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/line6/podhd.c
+++ b/sound/usb/line6/podhd.c
@@ -507,7 +507,7 @@ static const struct line6_properties pod
 	[LINE6_PODHD500X] = {
 		.id = "PODHD500X",
 		.name = "POD HD500X",
-		.capabilities	= LINE6_CAP_CONTROL
+		.capabilities	= LINE6_CAP_CONTROL | LINE6_CAP_HWMON_CTL
 				| LINE6_CAP_PCM | LINE6_CAP_HWMON,
 		.altsetting = 1,
 		.ep_ctrl_r = 0x81,


