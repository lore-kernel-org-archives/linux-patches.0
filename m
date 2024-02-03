Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6285D12B6D;
	Sat,  3 Feb 2024 04:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933617; cv=none; b=fm1FU/Di2q4szjUABZWC1weqZYrJ1HOlQ4Ijc9l3eF6Y3FO1DZ18+/Br7nVwIc53Jaf93MIl4yf5JdHvofvjbG8pEfqZb47Dbx2dCd/DJhDt3qhHdg5wuVOcsdS9yyznIXeRs0wKBkhL3dyNKObzPz24nijjBl/bL0b4hMLNptk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933617; c=relaxed/simple;
	bh=HO+C+5PdHLtgm9ljxUZxeJDdhsuuMx+Sl5GzU2tg2xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlcKfr3Frd57fzuxBFVmLPWoj/3C2A+OUhwAoUppGsaMJYyRs9XLphWIyur21ZXgyhcyxsCChQ5KGjVZCbNf6hLl2Yhi3C7JYUdporIRslHLOYAd4qaglusIhqOuhto10pERd6UEREdjabZ7hoji5csB3vuCCyiRSxn57ZOqL7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYMRY6fd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYMRY6fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCAF0C433C7;
	Sat,  3 Feb 2024 04:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933616;
	bh=HO+C+5PdHLtgm9ljxUZxeJDdhsuuMx+Sl5GzU2tg2xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYMRY6fd05V5hHxY9GaWH6zWUNZ1ZjyIEIPyt+qLamzw23UdD3QZpwkmbOBxFG0wE
	 HuYvICq8/FYta7UiHTNZqgLrJ6z2z3wEWJcK/u3LpYXjlfSPxaRyIN3HOjOgdkx/lf
	 WjfORenwCfljc4Qdo9HiH6jsIRiJ/DHMtpHRvPb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/322] media: ddbridge: fix an error code problem in ddb_probe
Date: Fri,  2 Feb 2024 20:04:48 -0800
Message-ID: <20240203035405.418921202@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 09b4195021be69af1e1936cca995712a6d0f2562 ]

Error code is assigned to 'stat', return 'stat' rather than '-1'.

Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ddbridge/ddbridge-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index 91733ab9f58c..363badab7cf0 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -238,7 +238,7 @@ static int ddb_probe(struct pci_dev *pdev,
 	ddb_unmap(dev);
 	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
-	return -1;
+	return stat;
 }
 
 /****************************************************************************/
-- 
2.43.0



