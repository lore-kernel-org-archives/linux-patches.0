Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829252;
	b=TnbvC/S0B8UyLHOR+3JnXJdiOXNSVD5Mlah5Pc8RJPD47yV8P+x7CH3gNqWRh0SFzPBb
	 TusicWe5GNk+ZtSBlDwp4iYL74JCLV0MENp6k532F7qSADeMwinAIEtDl5R7hI25xGh+p
	 dryABX0nk3Ne2GQ3Ydayh6tUXYJnXQZrioPPLEIARMfeKg76QzwWTNoc0Qy4piKACp/vI
	 VGBNJmhWjm7UuR7bytqzV8mi3W20ueGmMnejBMGeh9++JOokPANMsHW3Qn3kqun+z7gll
	 HgAduXN5jqRawOF1gu7PP3v2a9BDXQp1dMDGEbhhuW1l4Ku86+zUNnqJxycNPy7qZLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=URqJg1PvblskWlJ0QNer6lk0/xYvXQMJZEbPxyrdLOc=;
	b=d4xKOTHjfYwec9KK5xZiQD/4uSfNcLmgjG8rSBzjWnkvu5Tuwhy42cZCyrt3TmOYMWr5
	 XlGvhKlWBjXjX0jhkILKKvD+c/lOUX1oHHrD/f2vCIvi+z2qJ5KXdGgWN5e5NkMsn9/Rn
	 IyBqx6Mc3rwyPvhWNd/vLYNRUbrdtiHUD503BQcvtLdthl3xASOCbgcWzJBwL3Rcm1Hp6
	 T20dwb/8hlYrC8gEHhRtKdRU34lCrHFGoj4WG+71HjUU0Q2+wYcxpECYDGGq51mHAynNg
	 dnSXM+AC3WtTNAryjS5uKSDoEEFaZBeRI1II1r2GihDhY8ytlVyl2lhVjwBx1sTgzJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnnIjkbl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462CF6070A83;
	Wed,  4 Nov 2026 21:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnnIjkbl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8C61F00919;
	Wed,  4 Nov 2026 21:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829252;
	bh=URqJg1PvblskWlJ0QNer6lk0/xYvXQMJZEbPxyrdLOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LnnIjkblGWoCqFz+rk+gUPR8dhPfG4NQhLfETS/adHT73a8PetqbPBORYrYmsKLUe
	 Jfki0v0p0Sxcy8wvwCPUQJC+89gZUO2tSp5BFGea2XPUfs6XyB02ZmTuoIQosDAv6m
	 I0IKGc2V9hJ8Jwh0MJgs/NhQR2EWTD+NAzU7i6nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>
Subject: [PATCH 7.3 517/547] accel/amdxdna: Add support for AIE2 revision 9
Date: Wed,  4 Nov 2026 16:11:41 -0500
Message-ID: <20261104211053.084011293@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

commit 63e91c1997898f32f68a5dbf68195d68b8e58443 upstream.

aie2_get_dev_revision() fails to recognize AIE2 revision 9 hardware.
Add AIE2_DEV_REVISION_GRGH to the list of supported AIE2 revisions.

Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260929181459.928468-1-lizhi.hou@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/amdxdna/aie2_msg_priv.h |    1 +
 drivers/accel/amdxdna/npu4_regs.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/accel/amdxdna/aie2_msg_priv.h
+++ b/drivers/accel/amdxdna/aie2_msg_priv.h
@@ -530,6 +530,7 @@ enum aie2_dev_revision {
 	AIE2_DEV_REVISION_GPT1,
 	AIE2_DEV_REVISION_GPT2,
 	AIE2_DEV_REVISION_GPT3,
+	AIE2_DEV_REVISION_GRGH,
 	AIE2_DEV_REVISION_UNKN,
 };
 
--- a/drivers/accel/amdxdna/npu4_regs.c
+++ b/drivers/accel/amdxdna/npu4_regs.c
@@ -153,6 +153,7 @@ const struct amdxdna_rev_vbnv npu4_rev_v
 	{ AIE2_DEV_REVISION_GPT1, "NPU Gorgon Point 1" },
 	{ AIE2_DEV_REVISION_GPT2, "NPU Gorgon Point 2" },
 	{ AIE2_DEV_REVISION_GPT3, "NPU Gorgon Point 3" },
+	{ AIE2_DEV_REVISION_GRGH, "NPU Gorgon Halo" },
 	{ 0 }
 };
 


