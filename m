Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043876;
	b=Ihc7ZUNPIeSbDy1cEr4QCda7WZswL26i3aCj7tO/Gqh5fB81BwLiwUSfh0pP8O2PDxC/
	 SXspv9ie4ggSvtXGaidJDXlQ4WJI0GeflJW4Yi7BfQGNNvdq9DOPdhnKBIDEePh6cizB6
	 mBleL9xWg5Otymlu9NS5Cd9HH6n0gSZdawVF0Li30+On2R7KynWuTa3aMa8G30GmMeHXp
	 09Fv4ysX74HIZiuptogAy6Vc95fHuKCFEJPPBAogj2JrdNrnbFtLjS4oxt536CjSnQzTe
	 ZVAU/3cagvTTERW73ZTiQf8oYf++Z4S57vOBoVW6N3z8WYvedwolVUZ6pPNA3RZbhIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UebCYHX2evehaMY9EfGZ+svG2KsnYk3q+4QGW8YP6aM=;
	b=KmWGHHO45m00Q5BRbOP532ep4d+jfLYx1U5vvL7Ccnzna32ug9DhsKYFwk5DAyTZE8HQ
	 CKzD3wWJLYexyIlycYnfk4OrO/IGt3jCM6EDvx1NXscQJ2lEASdVWYuzLkVJthymDE6gx
	 BFnb7PgIPxPLwRBvGyrPMUFtl4AwTkuwt4ELe2BlB2G+Ft8+zPw5zndcHpT6PYcPhB4EL
	 QVeXRP+Bb0sIuyfilm07RWoQkFTY7I3eIMqtboj7yHr/jIqVA1WcvtBF6GKARrk1lWxYN
	 U7B2znwLgSWHyEgNZw8HhkxfNxDZEG98mBuRWTSEmJb518jy1Jsm9z7R5SezfIgDdRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PtppV8tj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0725F606A31C;
	Wed, 18 Nov 2026 23:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PtppV8tj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC631F000C4;
	Wed, 18 Nov 2026 23:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043875;
	bh=UebCYHX2evehaMY9EfGZ+svG2KsnYk3q+4QGW8YP6aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PtppV8tjr/ua6L5g+L6XmEBZCJt3EtNgh8gSGtiLgfMt4c8evaZ2+2V+DZoii6Z6d
	 hJSzLm9L4NxhR686T2wLG9uWKqEOwpskeekZswabiLQNOZzuh5V+MgZYSeDfENbJ3J
	 i4chKw7JXWzcek/XN/j+2SwdcWljaVxMGfwHTA8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Thierry Reding <treding@nvidia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0326/2857] drm/sysfb: simpledrm: Improve framebuffer-size validation
Date: Wed, 18 Nov 2026 15:22:40 +0100
Message-ID: <20261118150213.180092049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 03f1a3545b721fa7fdadd00080e237519a286a97 ]

Validate the framebuffer size from the firmware against the
limitations of struct drm_display_mode. The type only stores sizes
in 16-bit fields. Fail probing on errors.

v2:
- remove unused function simplefb_get_validated_int0() (Sashiko)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Cc: <stable@vger.kernel.org> # v5.14+
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Link: https://patch.msgid.link/20260625094509.157581-2-tzimmermann@suse.de
[ sashal: Kept the local simplefb_get_validated_int0() helper and added a U16_MAX upper-bound check inside it, instead of switching call sites to the shared drm_sysfb_get_validated_int0() helper that doesn't exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/simpledrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tiny/simpledrm.c b/drivers/gpu/drm/tiny/simpledrm.c
index 4b5ccbb13ecfe..fd9d7858e491a 100644
--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -50,7 +50,7 @@ static int
 simplefb_get_validated_int0(struct drm_device *dev, const char *name,
 			    uint32_t value)
 {
-	if (!value) {
+	if (!value || value > U16_MAX) {
 		drm_err(dev, "simplefb: invalid framebuffer %s of %u\n",
 			name, value);
 		return -EINVAL;
-- 
2.53.0



