Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030761;
	b=R/SasfEzYfYmjRFFDR708tiAcrKLM+GgUr3qkPfkHZG7tcB1NkFwfqVkQdKTighLmolZ
	 T88wBVv6z2fI8Vid4DhZLKGHDa0QfbS+lk5QkEj7VDe289enzX3WEhwWaMEdgljHfFgv5
	 u/31yHud9esAJtOUHDS0SajBbiBeiCxGlfSxbK0Mrk/2nEk7JliuDVhopQivhWyAzIPXk
	 OpOb1rQM8vVXSNBeAdGJv8giMMOPK8sWP7bZn6CgDsp6oJ+h9nrsIVkfV93rn1i3HHn+2
	 nsWpIDJ/73Qd8Jw4WesyTV0gZc/sL9RengTzXElxtcL/7J7viHfLDFcL+bKUCfNaTJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KlEXykxrq/ny2Pq/uOwTGL9piqpmHTwZsNPSeklaL5Q=;
	b=rXpcAIRuHWBto0DsFz5zAhb9yBfeyR9rQuRE4MreRCvS0u9bNUflnhbzbbBhL3TYVDXV
	 TM7XCrZ9xPgGI6W29AMSRw/AwIrrZL5GUSLWzP66mrreq1UUlruSpKipEgkqVdQjYTnga
	 1fN472ZpaBOGe5sQ91WCWQez2xfUOOKRietP7FtGw5ItIH4qRCOy5I2jh7vtL994TgLM1
	 UHXtCTcE5AO8L7b6XBu+gwpzFnVVn+HFnf+9N/0BYDMFC0rKdD4nXxgNpwHm2DGkyOILh
	 ZhHr6es8nxcN+M+kFXQ5+0RgOw/gLVJoLLi8zNGbYjaEwpYdRn3++d7cInrkfmLR+Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jxhvZxhO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE274606A932;
	Wed, 18 Nov 2026 19:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jxhvZxhO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFE71F000C4;
	Wed, 18 Nov 2026 19:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030761;
	bh=KlEXykxrq/ny2Pq/uOwTGL9piqpmHTwZsNPSeklaL5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxhvZxhO8bOg5X8H7aQjSuiJDc42o1DHe0EbhK04c+SXDiDhexsFlZexEllBW/1tc
	 NZ1s3bBSVOL6fVMwYOSTG5LTTUpuBKtNYiAztu4eP00DCOh/Xn8FS61+KBbBmhGpAf
	 ehS4wBnXiaORuklotZcG54C2tONia5pUjGbq9WBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0818/1756] perf/cxl: Accept an overflow interrupt on MSI message number 0
Date: Wed, 18 Nov 2026 15:49:05 +0100
Message-ID: <20261118150042.145551989@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit af06fba45746058ba8f983a0ac2f457a3404edba ]

cxl_pmu_probe() rejects the PMU when info->irq <= 0, but at that point the
field still holds the MSI/MSI-X message number the device signals overflow
on, not a Linux virq. That number is 0-based, and -1 means no interrupt
support. Message number 0 is valid and pci_irq_vector() takes a 0-based
index, so a compliant device signalling on the first vector fails to probe.

Reject only the no-interrupt case, matching how the CXL mailbox and event
interrupts handle it.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Richard Cheng <icheng@nvidia.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index 5fc4799d1ec14..09b9eca802525 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -870,7 +870,7 @@ static int cxl_pmu_probe(struct device *dev)
 		.capabilities = PERF_PMU_CAP_NO_EXCLUDE,
 	};
 
-	if (info->irq <= 0)
+	if (info->irq < 0)
 		return -EINVAL;
 
 	rc = pci_irq_vector(pdev, info->irq);
-- 
2.53.0



