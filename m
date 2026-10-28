Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209205;
	b=QYAav+gEYTupuad63RwjOq05qtSqkfFLgFR9VpqeLLitUd3ZhYNfaCSWlLsrcP+tf6P0
	 /nd3plbmmx9nG3Pfk+HeQrfxLxWgB8TfwhGkSyigpCKb2rEt4ajHF+e5sz9UOwDZCfLC4
	 rngeMlYOv+wJOKbsWO76M9em0Eg2bo0q06sW1UUne5WBDM4JmCYNsCS7ZI8U6JiNmJxR6
	 yscSLZySI2Tu8QSPhjujL7byaZpfGMLDklpAxiC79egthG4jxP7tFqbrgEqKLCd/qabA4
	 1emVY4wyxe7ItJc3sZFnn+Y5iJE6zOFYu6qhV1KXihTBlVblfYOFn25/8Py1LcTMcIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T/i6w7o1S9dl5d74Ziwuo9B5YY/ciiCciqtmXYyYyeY=;
	b=gV6m7xqSXjepQnXF2JFhaBVFSJvTCZyXhjy49GgqIqfwtcICQTmo7/HwC38mnRFYWXAc
	 rnPdG0nKY3U+EIT9k2bh2+dYYpOOj4ZY8DjgsPpu+0YXWQd6TM+xj1EE9zeiYlUESNx6X
	 KKdTwWG4LJnBImliD37f2tcp9AAsUInP5OST3wJtzPhD03x6qrjD7gkNcuGU7uPDG3BOr
	 6tb+Nlthp8DJWBQbRn6RoBxKRJEgcLLyHxYit0W7E2Q9aTBIRSCL27W6meGn9skP6BirG
	 LdF2wZxgO/SG9lthNke8aK5IWgPG0xWc8B+RRdUeFJtQmseqOtFoKlK07OgVb6WKvew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thWMDwGF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82C0606A31C;
	Wed, 28 Oct 2026 17:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thWMDwGF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047681F01825;
	Wed, 28 Oct 2026 17:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209204;
	bh=T/i6w7o1S9dl5d74Ziwuo9B5YY/ciiCciqtmXYyYyeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=thWMDwGFkiUbxZS3XVMGBD4xk9HN+gk64xFG5KCUYA9WlYnPoRYO7GH3/5N2gpUCX
	 JYIpikDE+nwChKx9lYbhqm05OzYhEbr7rTJwp7BCfrgjGl1prz8Q/WczI1necEz836
	 eW3QWc5hIcFv0ybfYbrULJesCdsiqnA239JaFHSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 390/516] pmdomain: rockchip: dont ignore clock lookup errors on attach
Date: Wed, 28 Oct 2026 17:59:02 +0100
Message-ID: <20261028170012.719158523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit 4c66c423593e26273ea0d644906ed007630c6f6d ]

rockchip_pd_attach_dev() treated every of_clk_get() error as the end
of the clock list, so a clock that exists but is not available yet
(e.g. -EPROBE_DEFER) was silently skipped and the device ended up
without pm_clk management.  Only -ENOENT means there are no more
clocks.

Fixes: 7c696693a4f5 ("soc: rockchip: power-domain: Add power domain driver")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
[ sashal: adjusted the patch to the Rockchip power-domain driver's older source location ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/pm_domains.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/rockchip/pm_domains.c b/drivers/soc/rockchip/pm_domains.c
index 19034afd2d7c9..6ccc85ad91c40 100644
--- a/drivers/soc/rockchip/pm_domains.c
+++ b/drivers/soc/rockchip/pm_domains.c
@@ -356,7 +356,19 @@ static int rockchip_pd_attach_dev(struct generic_pm_domain *genpd,
 	}
 
 	i = 0;
-	while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
+	while (1) {
+		clk = of_clk_get(dev->of_node, i++);
+		if (IS_ERR(clk)) {
+			error = PTR_ERR(clk);
+			if (error == -ENOENT)
+				break;
+
+			dev_err(dev, "failed to get clock %d: %d\n", i - 1,
+				error);
+			pm_clk_destroy(dev);
+			return error;
+		}
+
 		dev_dbg(dev, "adding clock '%pC' to list of PM clocks\n", clk);
 		error = pm_clk_add_clk(dev, clk);
 		if (error) {
-- 
2.53.0



