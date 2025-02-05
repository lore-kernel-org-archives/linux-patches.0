Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30711519B4;
	Wed,  5 Feb 2025 15:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768141; cv=none; b=adCKabV6nvkGNPCcJlcikCyHuavJSToUpMsVfhfuhPNb+k7XN+SODoqkex2Pl75NVex0ihWr8PCFPP9FKOHEFbnOoP9x3IJNcQa5J5m2Sq0uO3MnJsM7pKftGG1Wlt7Iu3fs83EatPD+yLfZA4NLY0VuGOEjYuMbTGa18RHtEns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768141; c=relaxed/simple;
	bh=cWyWt4tncCOIl+/IcRxy8lwfm7qzvxsNm0ywVJPGhVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/ogSJwupdGXpB4lyPgCoC3HyVqqdSziKdbmtxKY3IqentV6HK1eYKsCjQEo7U7xl+3CEc56JMNFrJ+E9XEOy/wKm1sin9ohd9USs4xIcjQiTkolPUfcJmdlpIp67OnZ6h+mhxSV/k/Wv21K/trHTHyAXNEquka051/ywn5h5S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=puKugNRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="puKugNRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518B6C4CEE3;
	Wed,  5 Feb 2025 15:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768140;
	bh=cWyWt4tncCOIl+/IcRxy8lwfm7qzvxsNm0ywVJPGhVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puKugNRIw1dOkyIMNueJk3tOT+lkDDnJwNorBvOFUcG2akiJpF/qeqQZarZQjnqUQ
	 GDzjMlC8+bkGhkWZ53Zj2idUFQPvysRwrOYcPmRKmcH6aUI+1+LrjpTeXy3hpRNtU/
	 qiudveg+392v99VJT4XeGZRg3XAtET9j7J/bfeIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 503/623] regulator: core: Add missing newline character
Date: Wed,  5 Feb 2025 14:44:05 +0100
Message-ID: <20250205134515.463432878@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 155c569fa4c3b340fbf8571a0e42dd415c025377 ]

dev_err_probe() error messages need newline character.

Fixes: 6eabfc018e8d ("regulator: core: Allow specifying an initial load w/ the bulk API")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://patch.msgid.link/20250122072019.1926093-1-alexander.stein@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8cb948a91e60d..13d9c3e349682 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4908,7 +4908,7 @@ int _regulator_bulk_get(struct device *dev, int num_consumers,
 						       consumers[i].supply, get_type);
 		if (IS_ERR(consumers[i].consumer)) {
 			ret = dev_err_probe(dev, PTR_ERR(consumers[i].consumer),
-					    "Failed to get supply '%s'",
+					    "Failed to get supply '%s'\n",
 					    consumers[i].supply);
 			consumers[i].consumer = NULL;
 			goto err;
-- 
2.39.5



