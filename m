Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004C11BD505;
	Tue,  2 Jul 2024 17:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940017; cv=none; b=Aq9pU8Aih9qRHrgVisf0sQ6y4e4mMpijQwvXuigFLrPJtjCpuFxc7KnRoRcRcYzzbwzoQWJHL1IjvS0GeJujs39ARoq613kHeiHevV7i4YGuzA6DHuCuzDq1KHb2UNaKgVPTKM9JwiUTYU+hYlRhwaZGvO0NklLpQGZqngoVRoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940017; c=relaxed/simple;
	bh=VNi27uBQA+U+/T6pQbWkdad1HyfLNbWLpr40HJVOBQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfzo1pqfqbeOPZPb26N7StBOuOfuOZqUz3NPj7tmaqQyYQB39qMCwCsdRwZDkpewnPxZQX/pTD7qjFYVtHIZ7SMxiGeK/6DO78Zosb3N3n5JEAhsj/rBJb6cJ1/axMyJBqwkMZDNDheIdqT7uQcPsDvvZwOqca3ez7jZBG/8Ezo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eB+hEk/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eB+hEk/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61158C116B1;
	Tue,  2 Jul 2024 17:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940016;
	bh=VNi27uBQA+U+/T6pQbWkdad1HyfLNbWLpr40HJVOBQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eB+hEk/qjj07A3n0SuLTpC+sfVNqAMke5GJUZ2tjmvIAtZcdCKbJDYy7v2WJTCjvB
	 U8KYylBcL4HGyhUyNV/JamYk2QLVbs3rqaoUwec9eHxTerN7nSyNhox/s5c56DYdNt
	 VdGG8iqwnEsynVlCwF8PvGtmvnA9Sya6HDjYtLxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 028/222] ASoC: amd: acp: move chip->flag variable assignment
Date: Tue,  2 Jul 2024 19:01:06 +0200
Message-ID: <20240702170245.053634406@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 379bcd2c9197bf2c429434e8a01cea0ee1852316 ]

chip->flag variable assignment will be skipped when acp platform device
creation is skipped. In this case chip>flag value will not be set.
chip->flag variable should be assigned along with other structure
variables for 'chip' structure. Move chip->flag variable assignment
prior to acp platform device creation.

Fixes: 3a94c8ad0aae ("ASoC: amd: acp: add code for scanning acp pdm controller")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://msgid.link/r/20240617072844.871468-3-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp-pci.c b/sound/soc/amd/acp/acp-pci.c
index aa3e72d134518..777b5a78d8a9e 100644
--- a/sound/soc/amd/acp/acp-pci.c
+++ b/sound/soc/amd/acp/acp-pci.c
@@ -100,6 +100,7 @@ static int acp_pci_probe(struct pci_dev *pci, const struct pci_device_id *pci_id
 		ret = -EINVAL;
 		goto release_regions;
 	}
+	chip->flag = flag;
 	dmic_dev = platform_device_register_data(dev, "dmic-codec", PLATFORM_DEVID_NONE, NULL, 0);
 	if (IS_ERR(dmic_dev)) {
 		dev_err(dev, "failed to create DMIC device\n");
@@ -139,7 +140,6 @@ static int acp_pci_probe(struct pci_dev *pci, const struct pci_device_id *pci_id
 		}
 	}
 
-	chip->flag = flag;
 	memset(&pdevinfo, 0, sizeof(pdevinfo));
 
 	pdevinfo.name = chip->name;
-- 
2.43.0



