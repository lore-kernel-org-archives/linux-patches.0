Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618774;
	b=0MksxnBig+ZxtF0LRIjkOOg1BgYVBnbTtSZ38teuyyrH89AMpLP5tgXWunDQr0JLStKl
	 5OhuZtfDeFUGqdNBEdc1iaaDV3OZ+Txr4bbPrBHXGAPfGuGE1lJ4fMhNqxJvgBc/HUvJ4
	 OhtHXWKDo4L0JB0giTkaBOtoCdw7eKiu1FnVaSHE61ipv7DdqaOSuRK7k1iIqV7VG+mSi
	 tQw70x0OWZf/FGhXSd1ifcYN5MmcXxQJkI2KEeU02OcYnXLAQqQ4zMJgO7Z4qWhlBMJzm
	 BzcbHv+y5HQUt3XrzKhlghHa9QsUjyC0qmMh1bFtoyV5LibKTfFPA29CckEONQFDzCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a4occAV4tBPzXkGWWufhsBd9HpAThYxO8t2vn8p1ulY=;
	b=prcnJZIE7BqH9CK3Y5EhB+ujY3Pvx2eErRj8z7KV2bUMJfZddMbhpHgvFhqDge/Pot9D
	 e1YtszEqFUoJYvABkFdw1hREB1iLfF7qRyWUXv5uLRS2TwFiOhzciSTx/SpWRah19yEM9
	 GBkBJJU4i2MWqGwCKTMuw3GtOZ3sruWWgteWYe5OPdrIu25qvTi43vAkMpq5Ptiy2S/jF
	 eqyyohkIThVMfwNh3K3L1UGUdDfeiebdButrXk7+KkORig6t/5+0ILJgTUDJaMYD06rF1
	 C7HUpN6CJQIFFatK7HK5aHDg/8L2e4VzRP1CccGn2ND59r30U9nyiLPLa3T6qBVXd/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2MwZuZAN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BCE606A323;
	Wed, 25 Nov 2026 14:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2MwZuZAN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1C11F000EB;
	Wed, 25 Nov 2026 14:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618773;
	bh=a4occAV4tBPzXkGWWufhsBd9HpAThYxO8t2vn8p1ulY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2MwZuZANjDp8bji4f3atfGWK0m3MhAEqQ1+IKmturL7E/d75snBTLIhN6rpq7vqKR
	 71xyHv0I1nUFLuxKFFRWudM9+4FQf0CX0HaRaLNf7jMBvdtZp8jc6gFBW2talramhx
	 LnXxtC78yVhMXPe2ebBITGnfC+oTgym95F4e7Ags=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik Poosa <karthik.poosa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0385/1005] drm/xe/pcode: Increase default pcode mailbox timeout to 10ms
Date: Wed, 25 Nov 2026 15:28:43 +0100
Message-ID: <20261125143830.758624203@linuxfoundation.org>
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

From: Karthik Poosa <karthik.poosa@intel.com>

[ Upstream commit 8721a51d44733b8b5cb41fa1bfe7fac2cf55107b ]

The previous 1ms timeout may be insufficient for some mailbox commands,
leading to spurious -ETIMEDOUT failures under load. Increase the default
timeout to 10ms and introduce PCODE_DEFAULT_TIMEOUT_MS for a shared
timeout definition, in line with pcode mailbox specification guidance.

Signed-off-by: Karthik Poosa <karthik.poosa@intel.com>
Link: https://patch.msgid.link/20260907083520.192418-2-karthik.poosa@intel.com
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: 94099304b80e ("drm/xe/hwmon: Fix pcode power limit handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pcode.c | 2 +-
 drivers/gpu/drm/xe/xe_pcode.h | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_pcode.c b/drivers/gpu/drm/xe/xe_pcode.c
index ccdfc33cf5876..6e41075ae9f69 100644
--- a/drivers/gpu/drm/xe/xe_pcode.c
+++ b/drivers/gpu/drm/xe/xe_pcode.c
@@ -141,7 +141,7 @@ int xe_pcode_read(struct xe_tile *tile, u32 mbox, u32 *val0, u32 *val1)
 	int err;
 
 	mutex_lock(&tile->pcode.lock);
-	err = pcode_mailbox_rw(tile, mbox, val0, val1, 1, true, false);
+	err = pcode_mailbox_rw(tile, mbox, val0, val1, PCODE_DEFAULT_TIMEOUT_MS, true, false);
 	mutex_unlock(&tile->pcode.lock);
 
 	return err;
diff --git a/drivers/gpu/drm/xe/xe_pcode.h b/drivers/gpu/drm/xe/xe_pcode.h
index ba8a1d1b21521..7e43792b0037a 100644
--- a/drivers/gpu/drm/xe/xe_pcode.h
+++ b/drivers/gpu/drm/xe/xe_pcode.h
@@ -18,6 +18,8 @@ struct xe_pcode_version {
 	u32 engg;
 };
 
+#define PCODE_DEFAULT_TIMEOUT_MS	10
+
 int xe_pcode_init_early(struct xe_tile *tile);
 int xe_pcode_probe_early(struct xe_device *xe);
 int xe_pcode_ready(struct xe_device *xe, bool locked);
@@ -31,7 +33,7 @@ int xe_pcode_write64_timeout(struct xe_tile *tile, u32 mbox, u32 data0,
 int xe_get_pcode_version(struct xe_device *xe, struct xe_pcode_version *version);
 
 #define xe_pcode_write(tile, mbox, val) \
-	xe_pcode_write_timeout(tile, mbox, val, 1)
+	xe_pcode_write_timeout(tile, mbox, val, PCODE_DEFAULT_TIMEOUT_MS)
 
 int xe_pcode_request(struct xe_tile *tile, u32 mbox, u32 request,
 		     u32 reply_mask, u32 reply, int timeout_ms);
-- 
2.53.0



