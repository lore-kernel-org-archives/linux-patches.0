Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030448;
	b=W8gZs7Rb41QoxklXt/eQCEoORzqjN9lezGFa0foUMCUMi7LbEurV27GTSz7GV+OWgkcS
	 0N+SKjwUmeVBU4uoOQaVK0CQabDPte5SVLwYDDkodGQ98XTA2rX9Jngj5YMksezZnFS42
	 8zpRE43E03hmS5Zi+26le1ZOA7toGzfvsn7vU+8zyvSgt2vuhCgFgt2higPQRKJWNv6a/
	 mkfKNd66C1/N0A1y5oGZXje1CC61QTsK4VW0aPGFRkHs9BPGl/KRk7sy7Z334nGeC2X2N
	 I5CCfQDjGlS7e0geBDEiFlLF5oNKZuhwYB04exbpdAhwdjSs78X+l+VeVKc0Ne7fEow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qyws71v4X1hhPXYcutdSUjiVaoMRHzcLtv3fTrUoHnI=;
	b=psPUiY3U/ErBpIGh2zdfi1J+L1MOioutiHpzlcnoKMoix2KciVb3mL9AgLpKdN6xy0Gu
	 6qXuzDf8eRVXxLNJrO61pwmrNyu0lTU4x/jKvQV9LrzjwSlWcNpGwaqUizh/RGrcmsGg1
	 fLb/5/ASoW/ut204lO6VIEMVDxTFL/6TtczOvvMZnG7OGF+/wFzeMSkGdJN+w6J+tkWI/
	 7GY5BYxIzEri3bYWf8W08pTJ6wSyU/RDAO2ySNF7eJgwOwEOCjvWX5oeEdWPk+mZidZzZ
	 XdSWqWB7BMdqmMEJYHRkrjnLI+/mywhfUARmA69qsuEvEP8os75fa4jQhGeAxae9tXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FclrKOLI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A79A606B10B;
	Wed, 18 Nov 2026 19:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FclrKOLI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9818C1F000C5;
	Wed, 18 Nov 2026 19:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030448;
	bh=Qyws71v4X1hhPXYcutdSUjiVaoMRHzcLtv3fTrUoHnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FclrKOLIJfXhRR+mTU8bJsH1BEkBcNko7l4c8ii+Qp56UgWslL35W8N74uNCwSXjN
	 0naR4d2g6FVqJdcs17qewRlwM7HOruhRRIXXi8NEvHF0vRmBe0feNAWdJERYqQwifP
	 s9TfMTdMUvL39gQ7BUsp0xe0LavIf1q4kkJkCaeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0691/1756] clk: ti: adpll: unregister OF clock provider on remove
Date: Wed, 18 Nov 2026 15:46:58 +0100
Message-ID: <20261118150036.719640938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8885d28face50..0d729c9980a55 100644
--- a/drivers/clk/ti/adpll.c
+++ b/drivers/clk/ti/adpll.c
@@ -925,6 +925,7 @@ static void ti_adpll_remove(struct platform_device *pdev)
 {
 	struct ti_adpll_data *d = dev_get_drvdata(&pdev->dev);
 
+	of_clk_del_provider(d->np);
 	ti_adpll_free_resources(d);
 }
 
-- 
2.53.0



