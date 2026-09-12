Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E99A332EAE;
	Sat, 12 Sep 2026 14:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224848; cv=none; b=Z3OMX9KZQ7H/lW+ksA+7O50s5wp+Kj/mXmvezh+pqfkbRPS26V4pgi6mF/gNRqcuYP1fpPnndBOM07WY7g2pqOCY3EG4xtgc8xUSX1AMCv2JrGvT1MaMG8Fx45wQjHy6epEIJDcDgxMHRMe2BjNip2PiummvmbflLOece09Kqd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224848; c=relaxed/simple;
	bh=z3+Am6WT3HNTmn2fDwUWg8nahLHiLEHLmJiznNDO7Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SG6oQ+hIHOcIOrvS0eqx8raN9kgoNHonTqFtDIdIU9+TCx5q2C25WO1lmAQxjbEt8J2CPqEIs6mk9QE66dkUyez3jh1NfKyr1ShBpQEWC5nCR863tr7nRgOPcwrqfwNayGwO9tehrLzdwwoiZyJA6iMc1A1rxWAq5vtPaa940GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EyMmszwy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyMmszwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF3A1F000FF;
	Sat, 12 Sep 2026 14:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224847;
	bh=YLzHQa7qyHR4bXlZLce2leAfJPBVLoeA1HZJvhRKI/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EyMmszwyxzZp7k1ZJ86nFAf9hD1ejID+ZLLFiU6ShqJbEiQ28eQRk+hdgE5kEKDru
	 19k7UaIcCmZBKqIsTxIjIqbmQmlbH+ih4PQfoHZgq6FfNRi7TjIYsfH8KdQjACEyf+
	 TwRkBKDQcpzGY8ASCstOmXDwaJvjfIvVqrl1oZp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1076/1424] drm/sun4i: dw-hdmi: Drop TCON TOP port reference
Date: Sat, 12 Sep 2026 08:58:28 +0200
Message-ID: <20260912065631.400717076@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit d2a242e5688a17b79c89cd966cd31820c5096d80 ]

When the HDMI controller is fed by TCON TOP, the port node used to
enumerate the possible CRTCs is never released.

Fixes: 57e23de02f48 ("drm/sun4i: DW HDMI: Expand algorithm for possible crtcs")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/43ffcc17f7c3f94c1d7bd1ee89134c766e84df35.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
index 4727dfaa8fb98..af9be9ba8b96a 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
@@ -83,6 +83,8 @@ static u32 sun8i_dw_hdmi_find_possible_crtcs(struct drm_device *drm,
 				of_node_put(remote_port);
 			}
 		}
+
+		of_node_put(port);
 	} else {
 		crtcs = drm_of_find_possible_crtcs(drm, node);
 	}
-- 
2.53.0



