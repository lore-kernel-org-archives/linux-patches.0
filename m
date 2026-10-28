Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212292;
	b=pnwMfSBkSerKxrNviJAsib9Ud+5m0CF7xPQBD7tQxDI6aOGV7bOVW3L3K5NiySNhonfO
	 ShWCrj02qU8f7ZZb73ft5zcuOhjRjlhSdowAUz6TXgZYL36QGhyZQvLkMZr5Z8kaHdI+O
	 cAzhHoUAqYGCemCj943dhjuFyiWcKVEmhK+RUp4qhAVVPuHyAjw0zR6ROtfdnUWDaxNdi
	 T03HIvFl0ggyFK56reFxvI7qRDbx1K4PzKsF4+HJxiIC3cqFl5xs7+O0XDKMjefibe2Ks
	 TFTejqdGQ8h0ljK/D8xbCFPEajo7xyEnXAFa79VpUvwaE8lo69hfT9gAQVZK+fsPVmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ssEVhbfKQP+WSBzcwW8ekL+CzNI6hUmtHdosAbRnoag=;
	b=EVe7BS1CbQtzrAC3+ikm84WpAcMWP2W1JGzyBlttIw1/Vib18AsK2mNdDa5hY++5IbOY
	 TT2D7O2Gw40Dq3KHp+ShbSrqwt0WjFN3wcNiIrWBrj/G04R+jCTX+1QvhrSVci25eaQi8
	 u1hv8yD2k9k53XuKuG5CT4FNNWJfM5oyJYM+XZzxa6V6o2kDNBawmrlIq8jpVm3e56No9
	 Q9kaylMurphrsa1Emk6ST25uqcZgOj2YwU/ayKr1mQf6bIeWXXHpCHvHAN3pIVU/0YL68
	 N0ruTlNGKKu2++R7tb/JuXi/y7mLoWCcjaUH+rix9x3nSykAyMxcXF3ZTGQ2e7MrqTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X85yEbEF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B41606A31A;
	Wed, 28 Oct 2026 18:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X85yEbEF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86341F031E0;
	Wed, 28 Oct 2026 18:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212291;
	bh=ssEVhbfKQP+WSBzcwW8ekL+CzNI6hUmtHdosAbRnoag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X85yEbEFjp8DJr9735WSNW0DZ/6ljkF82JQEX2AQuPxr7W2OPqcy/aafstPAygsve
	 AtiN0BBqxfD0LG6hpOHTs4MfWP4x7qBjE0ZjRxuj8Un2oIjwpc7D2g+bbS0uWTTXAZ
	 jbhiRMdf88JZAH6NBCCEWDRFC2qdW0IHigg09sa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Xu Rao <raoxu@uniontech.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0102/1887] nvme-fabrics: fix DHCHAP secret leak on parse failure
Date: Wed, 28 Oct 2026 17:36:38 +0100
Message-ID: <20261028170501.555977388@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit afdee49a1b88ed9bb44e2b30e855297c169bcc53 ]

nvmf_parse_options() duplicates dhchap_secret and dhchap_ctrl_secret
with match_strdup() before validating the DHHC-1: representation.

If validation fails, the parser returns -EINVAL before the temporary
string in p is assigned to opts->dhchap_secret or
opts->dhchap_ctrl_secret. nvmf_create_ctrl() subsequently frees opts,
but nvmf_free_options() cannot release the unassigned temporary string.
Each rejected option therefore leaks one allocation.

This is easy to miss because valid secrets transfer ownership to opts
and are freed normally, while the malformed-secret path still returns
the expected -EINVAL to userspace.

With CONFIG_NVME_HOST_AUTH enabled, the leak is reachable before the
required-option checks and transport lookup. No NVMe-oF target or
working transport connection is required; for example, repeatedly
writing

	dhchap_secret=BAD

or

	dhchap_ctrl_secret=BAD

to /dev/nvme-fabrics deterministically takes the leaking parse path.

Free the temporary string before leaving both validation error paths.
Use kfree_sensitive() because the copied option may contain secret
material even when its representation is rejected, matching the
sensitive cleanup used for stored DHCHAP secrets.

Fixes: f50fff73d620 ("nvme: implement In-Band authentication")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index ffe433c470894..eed78e6f2cdf6 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -898,6 +898,7 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 			}
 			if (strlen(p) < 11 || strncmp(p, "DHHC-1:", 7)) {
 				pr_err("Invalid DH-CHAP secret %s\n", p);
+				kfree_sensitive(p);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -912,6 +913,7 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 			}
 			if (strlen(p) < 11 || strncmp(p, "DHHC-1:", 7)) {
 				pr_err("Invalid DH-CHAP secret %s\n", p);
+				kfree_sensitive(p);
 				ret = -EINVAL;
 				goto out;
 			}
-- 
2.53.0



