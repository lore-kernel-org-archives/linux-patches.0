Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015188;
	b=3p0u0DNlP1/x2QDGyj2pP6uDoMhaBGmTLdr9cLQwa/16FrM+UJnxIV3uJzlB0BXzZpYm
	 h1rW7z9M90YEY14xVlN60hjmRdKsNHxt1uVpp4DmAVjx2YesW2Z4gmiZ68vyzd1jpQLVL
	 yOGkvZCLh+qsb84MY6AL4Y2YhB/GlkQm7iESatTjnRbqCDqbII61TpPPKNTk2q2ZDqBp0
	 58i4S3eBK5/2wpzCEUqgdc4PtXaCFYyX6Sf+Mx+a/7kmO8g5wohYY0XP1fOgqF2j37OWd
	 GY1wugaYBhiJKHC803HOdGWtUwOk03sI2GcoM2jmfBRHuK4q0ZdLyODoGxUu4yTmuqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hf2oc9xLjoT/SjDGEKrllnp2Xp5h9TiaGvrrj8anbjY=;
	b=kcd8MgWpx7H4XWBUs4yoSQOiEJ5Lgog5FwrId4QroT4c7fPprBn86YwylKpONEYMrNd4
	 Vp8GGPuCwe8UWLOWvq89Qd2gAmqh5+hrHnIxcVef+dZD9j+15DZ97aees9H0ex5AObuY0
	 w3SNM+Z9gH3+IbOhPkwtQ8m43MrhPR62F8x4oEmQQAdRyWPVCy8ZDjVXN153qH7a/+fI5
	 lI+OtDsEO8hrobVbWEccpYHSOUiZfzp6b3tt5YS5yXu58LWLQYmH60wWLJO/C1Kf/QF/6
	 +y5yNGopX0IydzPrHxrZ9fpzQ9Afw3TFQwtPoF+MJTKs2LAntqMBPz0p5wcgyWUrCtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Of0YYo4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD8460A2612;
	Wed, 18 Nov 2026 15:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Of0YYo4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323111F000C5;
	Wed, 18 Nov 2026 15:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015187;
	bh=Hf2oc9xLjoT/SjDGEKrllnp2Xp5h9TiaGvrrj8anbjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Of0YYo4vkY0T7jVlNAmfwFVWc5SqHu5lVjCFWzkXb20xz6bXn2CmVNXhRqynGDnk
	 99tP4OmZJeAAlUTboD+S91rlfZLihIUt6+YZrRvLARfa2DO7TRKBsod7YopmfqXCL3
	 RbDKh1yOgCBjCnyetSD2a/x1KyRZWhrmPwa4mAOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Riana Tauro <riana.tauro@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0085/2651] drm/ras: Cancel and free message on get counter failure
Date: Wed, 18 Nov 2026 15:22:05 +0100
Message-ID: <20261118150250.972617767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit 9cc19bb8f2f6886392b9185b96bbef91b2f1a50f ]

doit_reply_value() directly returns on get counter failure, which results
in stale sk_buff and genetlink header that aren't cleaned up. Fix it and
while at it, consolidate error handling using goto.

Fixes: c36218dc49f5 ("drm/ras: Introduce the DRM RAS infrastructure over generic netlink")
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Riana Tauro <riana.tauro@intel.com>
Link: https://patch.msgid.link/20260818135304.497098-2-raag.jadav@intel.com
Acked-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_ras.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/drm_ras.c b/drivers/gpu/drm/drm_ras.c
index d6eab29a1394c..467a169026fc1 100644
--- a/drivers/gpu/drm/drm_ras.c
+++ b/drivers/gpu/drm/drm_ras.c
@@ -201,25 +201,28 @@ static int doit_reply_value(struct genl_info *info, u32 node_id,
 
 	hdr = genlmsg_iput(msg, info);
 	if (!hdr) {
-		nlmsg_free(msg);
-		return -EMSGSIZE;
+		ret = -EMSGSIZE;
+		goto free_msg;
 	}
 
 	ret = get_node_error_counter(node_id, error_id,
 				     &error_name, &value);
 	if (ret)
-		return ret;
+		goto cancel_msg;
 
 	ret = msg_reply_value(msg, error_id, error_name, value);
-	if (ret) {
-		genlmsg_cancel(msg, hdr);
-		nlmsg_free(msg);
-		return ret;
-	}
+	if (ret)
+		goto cancel_msg;
 
 	genlmsg_end(msg, hdr);
 
 	return genlmsg_reply(msg, info);
+
+cancel_msg:
+	genlmsg_cancel(msg, hdr);
+free_msg:
+	nlmsg_free(msg);
+	return ret;
 }
 
 /**
-- 
2.53.0



