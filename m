Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216840;
	b=f6rSQebDvuEEnccDh7I0IvXMXQ7xH4LSLUwOhc1IR3XhcR4CK3vuH+SXhtwE7eAtpQY9
	 znhg3vOHKeKi0fy6AAcUPcd6H16f6K7yafIdPKImRxHyqs/Dymy/MuyLXM9d5OtCAF/kd
	 /sG3oKc0FYilGSpBrGD+qCrYqUiDLt7SuW3EGorZO5ET960lQjwPS82JEbUC2D0UpgDF0
	 t2kluCu8GlbcDZu8gpGgjY6ofClNWPi8F+lgMC5dfvOqG4jr1od2IgZH4sVx0pTaLiRh8
	 tFAERSQoPWgH3JodOnCWph39sBsH7f1aUCVA+BTKkLamXHt8VgXbnGS1kc+y0p56+Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4KUTjotL+Oz214+qtVKp+PslGTpsnkF4UZemeeqB23k=;
	b=kqMotbsaZAz6hh4UT0rW5GQIt6cVUHqByNXaUTbW75geNxKh+NTN2oZPUo1AEbYpiuYe
	 OkLb4E0o4AB+3B5FdXvdpwpWTC+ParFb2NCt9CNnccM8h655OVnDbnOF26KNoJ+Njxb7d
	 HtupXWagJZkYI97xe30wlUGb3FNafPXvyqa6Dt8CpKOaR7BBQo4q/IdHwb46re4YRas7D
	 shXmZ8+76jbICcifRPN3AW1YfsoEWp5MhM9fv0N1YZQubBIVZrwveyR8lAgMV+bn8sb6e
	 elq3UgWkg1RNmLoC6lmHeVGKqylwVu+qECk+LC7iJFgA1lq3mZJwTe4LHCby0a+mfKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i6Gzhk/W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4DE606A31C;
	Wed, 28 Oct 2026 19:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i6Gzhk/W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1453C1F01825;
	Wed, 28 Oct 2026 19:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216839;
	bh=4KUTjotL+Oz214+qtVKp+PslGTpsnkF4UZemeeqB23k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i6Gzhk/WcJVXi2lwV+BwO9aRxxjKIpaQZuWgZSL3aUTfsZH+olg6DvQ7L12Cq9X2j
	 yqbDx2TCiJWPZuPBtDzEQvQHL2jaXk6bGfIBSygflOI6sLaV1iz5HxkFEAkCOTquBl
	 Bh6vX7iWH1cF0ur1Nru4UO553SG+K6Muj45yHo98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Koba Ko <kobak@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Richard Cheng <icheng@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1643/1887] cxl/mbox: Clamp mailbox output allocation to the payload size
Date: Wed, 28 Oct 2026 18:02:19 +0100
Message-ID: <20261028170536.853532645@linuxfoundation.org>
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

From: Richard Cheng <icheng@nvidia.com>

[ Upstream commit 8a13db9f899d149c3aab24abcb668121cfda5a4f ]

CXL_MEM_SEND_COMMAND bounds the user's in.size to the mailbox payload
size but leaves out.size unbounded, then cxl_mbox_cmd_ctor() calls
kvzalloc(out.size). A large out.size drives a huge allocation, above
INT_MAX it WARNs and taints, and with panic_on_warn=1 it panics.

The transport __cxl_pci_mbox_send_cmd() already clamps the response copy
to min(out.size, payload_size, device len), so the output buffer is
never written beyond payload_size. Clamp the allocation to payload_size
too, matching the RAW path.

Fixes: 583fa5e71cae ("cxl/mem: Add basic IOCTL interface")
Reviewed-by: Kai-Heng Feng <kaihengf@nvidia.com>
Reviewed-by: Koba Ko <kobak@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Richard Cheng <icheng@nvidia.com>
Link: https://patch.msgid.link/20260624144147.53997-1-icheng@nvidia.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mbox.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 3e89dc2b60d84..43df0a3d20f1f 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -281,11 +281,7 @@ static int cxl_mbox_cmd_ctor(struct cxl_mbox_cmd *mbox,
 		}
 	}
 
-	/* Prepare to handle a full payload for variable sized output */
-	if (out_size == CXL_VARIABLE_PAYLOAD)
-		mbox->size_out = cxlds->payload_size;
-	else
-		mbox->size_out = out_size;
+	mbox->size_out = min_t(size_t, out_size, cxlds->payload_size);
 
 	if (mbox->size_out) {
 		mbox->payload_out = kvzalloc(mbox->size_out, GFP_KERNEL);
-- 
2.53.0



