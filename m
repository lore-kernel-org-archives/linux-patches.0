Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018289;
	b=jc9++Wo0hgGTBPTOWKaSeRJIuobPw0gpd1XCQyaYWuKPoEn8Cm1uHraqENCshS1Y5QdE
	 TIShz4lMFEjfWWtOWFep9bOJO6gpy3oyxz6DC8HIWvG0fBLYNOuFMFAGL2OLqfNOWt0H2
	 ZzbwceRwo06CT8E1Xpvnq7YomgaLJys9p+ukUeEE3sZWaxBqSJzYl3/WS0YKmr1tjr3GS
	 i33QKulACfSk8bFa0utAnCd43WuBzroCFt1Lyx3W+zYEkk4T92d/dwb3SwMopeVRku+P7
	 GFbei3M7Cmj0QYYb7P6LG0ytl601R8vfZBacdOVAgG+H99slnwCd6zUXc4xQjW2Hy6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8V93jP5UD6oIXNla101i4jQlRmOI+e0ssiDCQj+9+rA=;
	b=fGNUJ89AXEcrYab3Ko2uq6J/n6teVZ5vJrsdrbANS1gT3glPXkfyJ/5tWzhicHcjym/w
	 cEoc/J+rPP5pVt0ScT8VSlYhl5feeb08Fhj7JvOX6a0lMqI+fYaYooTQhvwPKwXqTJdMk
	 8yxM4DD66lpS3Iqr56jmJblFVT+81L9XFBm1cGbB28DRY4Ag0D5jqNWk6Ks/6h8ZgmJPO
	 M6ueiDeFpQuSEYz4ypSZDQBlIp9AzQhV3TvJGDMdIP2ajAf0TYPbosTFEIyP8RvdySj5c
	 7O3n3ccT3r8d1MBSwl6CT06f3B++eqr3BKsay+0BOLoUW54WjNcE7w4gjk+fWaX5U7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KMC21sYb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EF4606A320;
	Wed, 18 Nov 2026 16:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KMC21sYb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7631F000C7;
	Wed, 18 Nov 2026 16:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018288;
	bh=8V93jP5UD6oIXNla101i4jQlRmOI+e0ssiDCQj+9+rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMC21sYb/jaloz4wDVVvK3xH2PMc3T5zvRHjsnPIK+XPxLvA1pE9p/vLUlyYSy6Dv
	 kp3OZ/2YhBl0tW3alRcU3OfqnXAq3NMjfbafBx1A8DDoXeouJBxtsFGXfkBSf3zjKR
	 yBeywRButS1lw+Eduomm6sjJe2HiD8RUSMi4C5VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ben Horgan <ben.horgan@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	James Morse <james.morse@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1188/2651] arm_mpam: resctrl: Dont stop early when tearing down a class
Date: Wed, 18 Nov 2026 15:40:28 +0100
Message-ID: <20261118150330.770682033@linuxfoundation.org>
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

From: Ben Horgan <ben.horgan@arm.com>

[ Upstream commit 1c39415492323b9c5fd4a59179b390d45c26778a ]

An MPAM class can back more than one control and more than one
monitor. mpam_resctrl_teardown_class() iterates through all the controls
but stops if it finds a match which means classes backing more than one
class aren't torn down. The same for monitors, in which case the mbwu
counters will be leaked.

Stop terminating the loops early.

As we are already changing mpam_resctrl_teardown_class() remove the
misleading comment. It doesn't call resctrl_exit() and isn't required to do
so as the only caller does it first.

Fixes: fb481ec08699 ("arm_mpam: resctrl: Call resctrl_init() on platforms that can support resctrl")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_resctrl.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 321741a702fea..9cec5843e8fa2 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1943,10 +1943,6 @@ static void mpam_resctrl_teardown_mon(struct mpam_resctrl_mon *mon, struct mpam_
 	mon->mbwu_idx_to_mon = NULL;
 }
 
-/*
- * The driver is detaching an MSC from this class, if resctrl was using it,
- * pull on resctrl_exit().
- */
 void mpam_resctrl_teardown_class(struct mpam_class *class)
 {
 	struct mpam_resctrl_res *res;
@@ -1957,17 +1953,14 @@ void mpam_resctrl_teardown_class(struct mpam_class *class)
 	might_sleep();
 
 	for_each_mpam_resctrl_control(res, rid) {
-		if (res->class == class) {
+		if (res->class == class)
 			res->class = NULL;
-			break;
-		}
 	}
 	for_each_mpam_resctrl_mon(mon, eventid) {
 		if (mon->class == class) {
 			mon->class = NULL;
 
 			mpam_resctrl_teardown_mon(mon, class);
-			break;
 		}
 	}
 }
-- 
2.53.0



