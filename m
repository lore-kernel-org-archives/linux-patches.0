Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061018;
	b=325aaCY8wBM2gS21WFqes9OVatzpaHnJ3bG6hVqyTkjVCSDThTjYjGmjFjdTEdLM5OBu
	 oqDplos6+ReHGf5RunTOH+TmmG1a07dFxcbQe7+UG4nV7r1WnZ2ZAAubeP5rBJ4vvfpgz
	 DK+MVIxPYsTDbDmGfZg2hSkmHRneAejtEx2e/PJzmIIH6IlwA8sH119fpV5ghltoXuyXG
	 vE+Vv/bsH0N4TuzJB8eElMqqHbiB85kcL26NBW0Y7qf+twZvWL9TFTA+ZFLBEYP74865A
	 WNn12K5otb3XLVADx8iIxK/ZCkdYdFdHCztAOLGEm+QqPACBF7CwGMT8l4bmP9iLF/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dD/WNnK6fdcHCgIHUtrZ12nUqg5EneI2w7Jk0aiJCVQ=;
	b=ODFfg+iU8JGJyc+/Sr40kzToUtRXNMIVFTJwDdFA6NVkbQnY2vIun+Ui3kCYtc4uSdtu
	 xnqgSxPvo491SOLtgDUXy6shFkQ+xhRe4uvTskVr4ieG0/zWxfN/BmaVJJ6ZSfHlxMuHn
	 BZxX6G8A9B9HLNyXUVnAvoceIcg3gpZFIbvSie3VVMTM+/OmlQAoj5XqJ9S7F4b1N6Iqa
	 IvEnyZxnEY6qTIGYVcRQKtBdVH8wk9Aq+LSQCyXWWFCQovw+62es9hsVpuniF5XTZC9cf
	 OQIl1fyV9UOxMWBkGzwRqQ1tFY+EN9jfdkXL77+IrbgnnxHxIxLrkCizmZu0zu+T3wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pCEJCKgH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A608606A320;
	Thu, 19 Nov 2026 04:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pCEJCKgH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1DD1F000C4;
	Thu, 19 Nov 2026 04:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061018;
	bh=dD/WNnK6fdcHCgIHUtrZ12nUqg5EneI2w7Jk0aiJCVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pCEJCKgHIycYax+n3Ekg0l6xuu+7UT947dXF4nwBi+a4+/z5rDGt0sW3swWAyOvv4
	 bzcmWJ4kbTyn5/iGLZgHUigwvelK5pUheF/NhVUaLRSRGRaOH3bPYvUsoujZE1NDB6
	 LeooJihA3RdCGC3xOJ3fDpiWW+w9PAccx/Jbelhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1403/1848] clk: ti: adpll: unregister OF clock provider on remove
Date: Wed, 18 Nov 2026 15:57:21 +0100
Message-ID: <20261118150018.257816503@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 4c943ddfc24340f1b899762b1ff35c38306b7a35 ]

ti_adpll_probe() registers the driver's onecell clock provider with
of_clk_add_provider().  The remove path only frees the clock resources,
leaving the provider registered after the backing data has been torn
down.

Unregister the OF clock provider before freeing the ADPLL resources so
the provider no longer points at released driver data after device
removal.

Fixes: 21330497f303 ("clk: ti: Add support for dm814x ADPLL")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/adpll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/ti/adpll.c b/drivers/clk/ti/adpll.c
index bb2f2836dab22..798e4835ce71e 100644
--- a/drivers/clk/ti/adpll.c
+++ b/drivers/clk/ti/adpll.c
@@ -947,6 +947,7 @@ static int ti_adpll_remove(struct platform_device *pdev)
 {
 	struct ti_adpll_data *d = dev_get_drvdata(&pdev->dev);
 
+	of_clk_del_provider(d->np);
 	ti_adpll_free_resources(d);
 
 	return 0;
-- 
2.53.0



