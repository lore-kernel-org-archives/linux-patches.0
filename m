Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617803;
	b=D0vYoivsuLUMEQzp6P5jJiCpD2yxm4KrfzJlZI8Ox6w7j93QggQJiEHCC4WFuMbjHIRG
	 I7ms8/eKe/7POrBH84oah1x4LBfsjIRs87fmKeFVmnmR8Mw+dJTn4ENEUBf10RNsALhoo
	 7q2ySl5jtL5alj8RHqg5t5Kx/jh+Yv8ex/y7kSWEZBwodOBSwFJx+ZJjkn5uox2SvzWJJ
	 yYBhcPCzAM5dDQNQ4eHazF8f2Ei4kfX3GuljO1LCMpS7hwYJ50j+K3zDFpLn3h+T5hrt9
	 fWeS2pAbszJjoSmHaJAmR0rY9M19iqmJM6UFEbS8GMh+8JV4fU/dVctLIQEQ1NpN8Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2dsC3tnmqARM7KRiWgO9uz6Wiai3wPRTKrzrMyjuKhQ=;
	b=CKDkawToUyvwnq0hrgniBy2hB/X4EYNn5M+U0eDravfcdhqFFXFfBaB3758uwulwS2MV
	 KpP7ybltYhWs5U0rgJtNlCBoBeN+QU44V7o+bSOkly9SYv1cp6fF2EdPBqb8uRnjp7eHR
	 XtJ5SBgbfcyy24JCo6BdQEj4U5JM4oj/geDRZhZxdrFOFpqTsfo0JizLbVpmKvz+MJOFu
	 9pL6kHy3fyKdGJYLa79ilmlm9uXF1vaNMGGhnqqiGAEuOmSmbHDTK2ZKcwNYhFZpHmCr8
	 MEa3GhUUx6+6wqvfznNjj/xpmL7B+92azGiQl/fF+Xf6Z6c50DUeb9EB6TcL2LjrNhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=keuO75wP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2990606A31E;
	Wed, 25 Nov 2026 14:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=keuO75wP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D211F000C0;
	Wed, 25 Nov 2026 14:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617803;
	bh=2dsC3tnmqARM7KRiWgO9uz6Wiai3wPRTKrzrMyjuKhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=keuO75wP6RuN3s0fJ5XwI8zgv+D00CMKxR4GSBe7VdC4I6YxdRREELs1quybFCvM/
	 vw/caqOXF0sYCkd8mIV5gta2XjYxuEfccZjzMlW1LilChxBNr9AhVZ5IRpanXGu/Mx
	 6Z87Fawf04x/hYgMRVZ2MPnyYhSzoVauUWr+ZxaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	James Hilliard <james.hilliard1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0080/1005] ptp: drain virtual clock sysfs operations before unregistering children
Date: Wed, 25 Nov 2026 15:23:38 +0100
Message-ID: <20261125143823.614380980@linuxfoundation.org>
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

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit 0e4a135aebc7686286d87e286499ce55e5bd5aad ]

Parent clock removal walks its virtual clocks before removing the
n_vclocks sysfs attribute. The mutex taken by ptp_vclock_in_use() is
released before that walk, so a concurrent sysfs deletion can pick the
same child and unregister and free its ptp_vclock a second time. A
reference held by the device iterator does not protect that separately
allocated virtual clock.

Remove n_vclocks before walking the children. Removing the attribute
prevents new stores and drains stores already running, without holding
n_vclocks_mux across a callback that needs that mutex. Skip virtual
clocks, which do not have this attribute.

This race was found by code inspection of virtual-clock registration
failure cleanup and parent removal.

Fixes: bfcbb76b0f59 ("ptp: unregister virtual clocks when unregistering physical clock.")
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Link: https://patch.msgid.link/20261026-ptp-vclock-sampling-v6-1-e705612541f1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c   | 5 +++++
 drivers/ptp/ptp_private.h | 1 +
 drivers/ptp/ptp_sysfs.c   | 6 ++++++
 3 files changed, 12 insertions(+)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 4111342d64f03..47ffc773065a3 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -508,6 +508,11 @@ static int unregister_vclock(struct device *dev, void *data)
 
 int ptp_clock_unregister(struct ptp_clock *ptp)
 {
+	/*
+	 * Stop and drain virtual-clock creation and deletion before walking the
+	 * children. Do not hold n_vclocks_mux while waiting for sysfs callbacks.
+	 */
+	ptp_vclock_remove_sysfs(ptp);
 	if (ptp_vclock_in_use(ptp)) {
 		device_for_each_child(&ptp->dev, NULL, unregister_vclock);
 	}
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index db4039d642b41..ec8633126d6b8 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -169,6 +169,7 @@ extern const struct attribute_group *ptp_groups[];
 
 int ptp_populate_pin_groups(struct ptp_clock *ptp);
 void ptp_cleanup_pin_groups(struct ptp_clock *ptp);
+void ptp_vclock_remove_sysfs(struct ptp_clock *ptp);
 
 struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock);
 void ptp_vclock_unregister(struct ptp_vclock *vclock);
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 7d09256aca724..1b4530be42a20 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -267,6 +267,12 @@ static ssize_t n_vclocks_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(n_vclocks);
 
+void ptp_vclock_remove_sysfs(struct ptp_clock *ptp)
+{
+	if (!ptp->is_virtual_clock)
+		device_remove_file(&ptp->dev, &dev_attr_n_vclocks);
+}
+
 static ssize_t max_vclocks_show(struct device *dev,
 				struct device_attribute *attr, char *page)
 {
-- 
2.53.0



