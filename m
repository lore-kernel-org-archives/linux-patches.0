Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212615;
	b=nsIQFTWavdaN3hWAFrKKfEvE1/F0doRCDSCu9nzqjy3P/bjlOEwF9qMUFF2efBisLryj
	 /7ueh5KBbin7QqW4UrGIzf2kxApyEstblS5cgJLRk+gqMv28ZH3avNhjDH7w2Rbkv2jA0
	 ZxQ7RU0zjMTkgQPI8UZD+k7/ACrlMRbH79XnwOZT/9bdtpjYzSlgJoh9ETa+xzxO5prRa
	 DjeNTyhdjnUhSLy0zTRD/EWgHQ+RMSyG9bgKzNiM6xr9KnjpYWklYUCfs6pqam4FY6Y3H
	 FHndWmQpQNuYkP17GNNkXyG7eEjk8lq7lKQfEbR4ajmVyqQ3mMJ/Y+BLmgy26CEG0Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kiH+YV57Y/ACCD8M7T4p6k1Uo1MndSaPdb0mKEFW7Sg=;
	b=Yt+vf4db4GhyQebVqfbvNT8/c/7ZbGT1rZAypbte9TuqhYazGEU7/wmgtStaYa/Hfh8y
	 FiRMa2AXBVKTm/25XK1S3sAD5ixa44ozXpoWz0Jy9SE9DRdaFSG+m/ethlKPZ2X6FF5Mg
	 0Mqx0l+T0aPzi+taxFuETWbdSzW5boJUSavjGWHx0/JKCQszNcVYA39u3DGsaGj9BCYt7
	 uLVfl1ZTrv4RoZPpbcGBZZOI5gnjLpBWxVGtYhq8Hqp4U8bugDY3OpslWFQ3owERRWyOc
	 241erk0Tw2sglz69PFbSZJ5N58StbqONgNXDz1JbxCs2Jb1GSvBWJedBckE6zvFfN8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvlZHj8a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FB8606A31D;
	Wed, 28 Oct 2026 18:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvlZHj8a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813001F01825;
	Wed, 28 Oct 2026 18:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212615;
	bh=kiH+YV57Y/ACCD8M7T4p6k1Uo1MndSaPdb0mKEFW7Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gvlZHj8aFZxSS5vSP5oSjmmfg7El4Ci9Z7RzsiyYkmWMy/nwRrKEX+aXVCfFTVTCV
	 ML8S9IiwWuypT8Cygn/2MNEa3Sf13IkX49ZFFOSNxHnTU9yiCkbxUG+pMqnMCZXR9m
	 5oUmnv/8VGGuE1DKaZ9//6F81TxtXNTUvlcgaB3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0217/1887] of/overlay: dont leak fragment references when changeset init fails
Date: Wed, 28 Oct 2026 17:38:33 +0100
Message-ID: <20261028170504.170336055@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

[ Upstream commit 1d62f0f2bc7edb12ed09f71203df0e47fa4efca4 ]

init_overlay_changeset() stores the number of initialized fragments
in ovcs->count only on full success. When find_target() or the
__symbols__ lookup fails partway through, the target and overlay
references taken for the fragments initialized so far are never
dropped: free_overlay_changeset() bounds its cleanup loop by
ovcs->count, which is still 0.

Store the running count on the error path so free_overlay_changeset()
puts whatever was set up. The store is guarded by ovcs->fragments
because on the allocation-failure path cnt still holds the counting
pass total while there is no fragments array; everywhere else cnt
only counts fully-initialized fragments.

Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/20260805204009.CF3891F000E9@smtp.kernel.org
Fixes: 61b4de4e0b38 ("of: overlay: minor restructuring")
Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://patch.msgid.link/20260831-nh-of-alias-overlay-v7-6-02754604805a@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index a869c5d9d8a31..ebd712dcf34fc 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -830,6 +830,10 @@ static int init_overlay_changeset(struct overlay_changeset *ovcs)
 err_out:
 	pr_err("%s() failed, ret = %d\n", __func__, ret);
 
+	/* let free_overlay_changeset() put the fragments set up so far */
+	if (ovcs->fragments)
+		ovcs->count = cnt;
+
 	return ret;
 }
 
-- 
2.53.0



