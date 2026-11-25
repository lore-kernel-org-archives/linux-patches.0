Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626023;
	b=oNHcNanyprd6ckZvb3clE3t6ZaBsIWREdh1g5a6vIXEQO31ZodUnF6q0960VqoAYAJbx
	 oJp+N4a5SVhpIUG+bMMhdP572N7o6rkxyP+Pp5Y0x1597gBt6EkH2fzaOexrQ8NR92/yY
	 U4zihRgD/I4tcvpue7q+BrU0kE1ol4QJKHlTSTF2iMkE7BkgTmNFT6/Ar4w4LSrWdP0cU
	 bkJ2HfF7uUDstGh4qu6C0xk7GrstVr7py67DmsV1HHVMytnXGTO1xb+70O1N4XWb6DIGM
	 XYNOQvMsMGHQaoXBxBYaAmXdKLEI+55m1DvlapueM/zzaEFOd1Fka5TfyGmtQWHwBPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dRZKA1Ajc3WHJcxzx97A6Cp/P6l20hX9Pl9AT/oty2g=;
	b=lcMZZEHJwgxDBHhkjUWxEVF0TsaPWAVDTAZBaAICG3UkpDO41bOcWFOPxBkyOSiMOJcF
	 9lOL5rJZKcQQmJ/Utu1Fbj6gA6271iFvOl9WlMAbqcN6lYjarUC2FWfX0/qTvhJ1728+E
	 TJPyhnKl5YAt89GzNLB3h+5/DDfmlBLExOdPfMEQnrYmO5TNWR9vNR2a1t8HvCaQttZ7e
	 DeDLRYLJs5i52CnXppVfVWfiB+K2FfgMHzub7AhxCCkhmzQ21s5KGP+h/J4JEPzo4+q+V
	 57LVR8Tf1KDxhdLzHEDXPmNQpHmJQKOpC/fLm9Fz+urgVH3N5jWNy+9Gj/pSMQ/1GgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EG2AaiBu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1EC606A321;
	Wed, 25 Nov 2026 17:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EG2AaiBu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7BC1F000C4;
	Wed, 25 Nov 2026 17:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626023;
	bh=dRZKA1Ajc3WHJcxzx97A6Cp/P6l20hX9Pl9AT/oty2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EG2AaiBuiDKkbcGD8LIx7o47nUDGSewix08NGcaACaUGNvtCujpDUtc+Yu+1YJhNK
	 KE/B0sUEFzJkFLuzDMtelU2sHqgvOe7l7vkVzv0PRVIZd8abW54+mqmGiZs5NX2f8j
	 RorgyxEJni6JS4/7eZ/QoPZNPvjQ1kDBnse4+oYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 661/816] wifi: cfg80211: preserve mesh A-MSDU lengths when adding mesh headers
Date: Wed, 25 Nov 2026 15:36:49 +0100
Message-ID: <20261125143904.479543531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -772,12 +772,12 @@ __ieee80211_amsdu_copy(struct sk_buff *s
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
@@ -799,7 +799,7 @@ bool ieee80211_is_valid_amsdu(struct sk_
 		    __be16 len;
 		    u8 mesh_flags;
 		} hdr;
-		u16 len;
+		unsigned int len;
 
 		if (sizeof(hdr) > remaining)
 			return false;


