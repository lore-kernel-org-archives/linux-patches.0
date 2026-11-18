Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059041;
	b=ZLfFO1upUMF9NVJ63Q+yBERFLaSWymmxAmoaiLIfw04vzr6my4nh1FDFwR8iAC95f+ax
	 JdV7CuTD9s3Fqutgu1fAS7BdAFl52pjnGhd3Q3NZ1L85FBRTUa1kyigp/STvedrqS+Axi
	 8Wi7UiN1wfrQoJGyL6K3mA8TEpAfSh+zXr8ogewNfD6GFikL0I+zIbbYJcYe951gtFsQt
	 P4izGdNMlLf0ayDPxOt9KQNKxZPgGkiORIMAnVxEo1Xeo8T4hot84SFZeAIJgrT1jmt+O
	 MSYO0ldrJlQutxC8W2juQbfX45LVo7zAOCGTnKocdS0TqKpoJMNu0XVYHX/ech0ITBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6JgkootdIALNeA4iVoeZ1RH8LiEvjDXPVONX7ql5Us8=;
	b=WNP8IpEQtBeIXlMSMMeHqbFmIZ3IY7jHYspoU6s9qMbOsi47rV+MEj6wlZpJgUJw36xl
	 VNQFABk9PRwfyaLAyxiJUb9A69X5f1rPKfyFlYUIQYR4tyfnwE/zjeLEsDHjrL9ginHDf
	 75e9zwK4RP2W9CfHo/mlq+5Q+221Xzy+ze8cEKk1nH+xbFv3/TsFCw4cTkomJ9oeOoS72
	 St7jFypif7pXZXxoVBz5990lgy4cwUO4sZk+MpqFfTsIiV07fCuDsyyKlaVKgdjkT583k
	 3tXUaufqjG5RIWW9nLh40DkqqCKXxLe+Dlj+bY08DcwU7eHxjXgBCu0jDODLocRmwhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iIPWhzIY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE2D606A320;
	Thu, 19 Nov 2026 03:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iIPWhzIY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9031B1F000C4;
	Thu, 19 Nov 2026 03:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059041;
	bh=6JgkootdIALNeA4iVoeZ1RH8LiEvjDXPVONX7ql5Us8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iIPWhzIYZL1w6ynIVz57T3FV50pSqr1jYZUC89ZoqJYNvpf75kPeX+29wuhFVhFzw
	 bDldtPiv5zEY9+YcHrp0L7XgMimhJYeoLR3lgr4zpMEdgU5NAzKpZd9ccd4XcDplau
	 vwUORM6ri21nG5yRXpYzBYqJvAGKBIep1I7j/Xlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0699/1848] vringh: reject empty / undersized indirect descriptor tables
Date: Wed, 18 Nov 2026 15:45:37 +0100
Message-ID: <20261118145945.136909640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fang Xieyan <fangxy@xiaopeng.com>

[ Upstream commit 60a792b97933a686316737838cd007d27963011e ]

move_to_indirect() validates an indirect descriptor table only with
"len % sizeof(struct vring_desc)".  A descriptor flagged
VRING_DESC_F_INDIRECT with len == 0 passes that test, so *desc_max is
set to 0 while *descs points at the empty table.  __vringh_iov() then
copies one struct vring_desc from descs[0] -- 16 bytes past the end of
the table -- before the "indirect_count > desc_max" loop detection
aborts the walk.  The over-read value is discarded when the walk aborts
and is never used to map anything, but the access itself is out of
bounds.

Reject any len smaller than one descriptor, alongside the existing
stride check, so an empty table is refused with -EINVAL and no
descriptor is ever fetched from it.

Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
Cc: stable@vger.kernel.org
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Message-ID: <20260926160755.21485-1-fangxy@xiaopeng.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index ba2c680b940a1..d7096bd8e4c8d 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -170,8 +170,9 @@ static int move_to_indirect(const struct vringh *vrh,
 	}
 
 	len = vringh32_to_cpu(vrh, desc->len);
-	if (unlikely(len % sizeof(struct vring_desc))) {
-		vringh_bad("Strange indirect len %u", desc->len);
+	if (unlikely(len < sizeof(struct vring_desc) ||
+		     len % sizeof(struct vring_desc))) {
+		vringh_bad("Invalid indirect len %u", desc->len);
 		return -EINVAL;
 	}
 
-- 
2.53.0



