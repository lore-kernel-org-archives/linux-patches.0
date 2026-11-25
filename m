Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620198;
	b=k25ULsli69RykJMIQikTdtTQ0cIyY5DsxkMQY3JmdUAhgjziRcYFz2Pxt1R6PS8F/Fki
	 2GRZIbIZAwykfQOGg8SALhD5ARG6wmpMdsHKR4AwpNKyFp5aPykMg62RT7OWsIz8/TeiO
	 z0HpTbj4wT20uWsC7tDAHckVQaUqUk4zvI4Bbi0/ESMlbqtrj+013C5HyGhTylq/+HwRS
	 dzHxDzAV/xvrnfYVHhJvJpi038JqIxwlmOdCSws8X9pTyQaGseWv42IRVaZysFmQRgC+G
	 Sr9E/hYChPBQqU0TaZTnFdEAP7eyFVHRTN5Qgd2V+b+bwZ4osSqpD1S2jeB4EU6awUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bDnDDWUn5ThQ7X17B4oqTIIMm34wFr4hNrFfHDZBfxM=;
	b=sQmCrCT9DIFmPmNjgKIALH+KIAbO5O/M31bxguAk/Uw3lc2oueiuAVjFBq5MImjfLleW
	 /DNleuS8dUW8EEAzvagSTDc09JT5jTMIzeeco636a5P9CTMUn1Dt12wrRbZiQmyNxPgVg
	 eIxR6khmZ5VleZ2TFWcxGmm4Jbj2Vm1lwBrFKCGjqtNIDVdYqey6Sz/mnNSMDFFXTbLC2
	 MtP9oTUJeDGRZ/x3vo6lT+fXgiZATzS0+/6TnT7A8HTQyZh9qINaNtqnziggx5pMY7dfC
	 AMzrn+UyNQOGmlc9/v/xG4p5jM8CbnO5yT2n/GG03O68r3uE7XbKf/jfrtYxkXuZmRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F1auadNp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50C6606A31E;
	Wed, 25 Nov 2026 15:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F1auadNp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114DA1F000C0;
	Wed, 25 Nov 2026 15:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620198;
	bh=bDnDDWUn5ThQ7X17B4oqTIIMm34wFr4hNrFfHDZBfxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F1auadNpBLXR2U+jzYQzBvKajCfRrdYIq8QFirGkV10JaIeAJbiO5/Z4tiSiSaoDe
	 QiYb6Xt7oI5fiXh9s3S/VUKEfPQXOXjT0IsZwEqA8iglWMkV9pJZtHowO4+NTm4mHr
	 GOIHbVwrRvkwNHZNh9P4H1AvYC95BbxyIAz2Obws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.3 0796/1005] wifi: cfg80211: preserve mesh A-MSDU lengths when adding mesh headers
Date: Wed, 25 Nov 2026 15:35:34 +0100
Message-ID: <20261125143840.383953401@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

commit 9083da9dd3223068237395432323b407012aec1f upstream.

A malformed mesh A-MSDU subframe with a declared payload length near
65535 bytes can pass validation against a much shorter aggregate.

ieee80211_amsdu_subframe_length() adds the mesh control length to the
declared length in a u16, and ieee80211_is_valid_amsdu() stores the
result in a u16 local. The sum therefore wraps before either walker
compares it with the remaining aggregate length. The decomposer then
splits and delivers the malformed aggregate instead of rejecting it.

Keep the computed length in unsigned int in both the helper and the
validator so oversized subframes cannot wrap.

LLM assistance was used to find the bug and review.

Fixes: 6e4c0d0460bd ("wifi: mac80211: add a workaround for receiving non-standard mesh A-MSDU")
Fixes: fe4a6d2db3ba ("wifi: mac80211: implement support for yet another mesh A-MSDU format")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142149.13834-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/util.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -822,12 +822,12 @@ __ieee80211_amsdu_copy(struct sk_buff *s
 	return frame;
 }
 
-static u16
+static unsigned int
 ieee80211_amsdu_subframe_length(void *field, u8 mesh_flags, u8 hdr_type)
 {
 	__le16 *field_le = field;
 	__be16 *field_be = field;
-	u16 len;
+	unsigned int len;
 
 	if (hdr_type >= 2)
 		len = le16_to_cpu(*field_le);
@@ -849,7 +849,7 @@ bool ieee80211_is_valid_amsdu(struct sk_
 		    __be16 len;
 		    u8 mesh_flags;
 		} hdr;
-		u16 len;
+		unsigned int len;
 
 		if (sizeof(hdr) > remaining)
 			return false;


