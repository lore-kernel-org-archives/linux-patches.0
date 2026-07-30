Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE3E442FD7;
	Thu, 30 Jul 2026 14:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423567; cv=none; b=sZlH+o7AHuThoTk+2jBpvKHrGXkDT7yR1Xxx2WayJD+akxuIFs4o36eEgxuZiBP8MN7zNvof19CbrI4eDtW1zuJPuy23Mr1qCoT7n17zD2mlzISIbqFANUSS7EbcQbArq2wW6BRrJODURbkwpwsGuIJWF9Q1+dU68KVtxaBvbZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423567; c=relaxed/simple;
	bh=utfSjAilBCayvI7FJ98UOj9I6EBPl7zhae6oNB2+vmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvUdAtBwGLJeL25sNmV/afzv70PzLKMA2F1Urg2JOgimeZMXGMc4G0IjSZvYX4tUxqFAiiGozJOyuYvf7SoyQIptH/BJEy52b4pigI/9XwVqfocRljJuZ5kZLa7ZAAH5eQXJJJnAvJp1KjACxvXs9CDW2FcFNJsHl/rMMPpVsTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYrwVHAn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYrwVHAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75A71F000E9;
	Thu, 30 Jul 2026 14:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423566;
	bh=JWbTeqsnfUVOozkBNY3oTBH5feaKrkqVWcEoQHBx1q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bYrwVHAnUHXI8xnToK/ngGOOsAEhPx/boC7zA6nWnZoXEa+f49oA4vT/etcgExed4
	 1DWgojadMDdc2/Rnrex2hPpwZyLgATWJYfMJFVqJDVjE82ygeZfDpX2M7BCoL3Bsl5
	 0LMhdBu0Eu14JBCSh0kHTDzKdp+MHMMq01JfNFLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 090/675] ASoC: amd: ps: fix wrong ACP version string in pci_request_regions()
Date: Thu, 30 Jul 2026 16:07:00 +0200
Message-ID: <20260730141447.042842782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit f7697ecf6eab9d4887dd731038b3dc405c7e755e ]

The driver handles ACP6.3/7.0/7.1/7.2 platforms but the region was
claimed with the stale name "AMD ACP6.2 audio" left over from the
original ACP6.2 driver. Correct it to "AMD ACP6.3 audio".

Fixes: 95e43a170bb1 ("ASoC: amd: add Pink Sardine ACP PCI driver")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260707060130.2514138-3-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/pci-ps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/ps/pci-ps.c b/sound/soc/amd/ps/pci-ps.c
index 34efb42be768fb..8f37c250d4b895 100644
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -595,7 +595,7 @@ static int snd_acp63_probe(struct pci_dev *pci,
 		return -ENODEV;
 	}
 
-	ret = pci_request_regions(pci, "AMD ACP6.2 audio");
+	ret = pci_request_regions(pci, "AMD ACP6.3 audio");
 	if (ret < 0) {
 		dev_err(&pci->dev, "pci_request_regions failed\n");
 		goto disable_pci;
-- 
2.53.0



