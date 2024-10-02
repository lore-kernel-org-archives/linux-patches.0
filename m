Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6011D0438;
	Wed,  2 Oct 2024 13:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877215; cv=none; b=YKX6AG6HNoIWZP65bC8+rv/coOhNVYLR/myhdxQ1aVo58uupZIaPyZp6iU/0dhZjramHr0dFpF7SbPdQhsmZMISx+UWcY8hrk8k4TmhC/d0sRyzq4CE8OMO+kTjdhBB8Dif6DxQeSf0P4UGTdwui2ErYXhDw7GG+lDe0FkwIuSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877215; c=relaxed/simple;
	bh=ZRKdWTXOR/o/oCaJnYTqkyGztRN8qWnG5J1DaeGxemU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mP/2tHquJdhWTVgSbQXRn+8BR3FPlgjPSISrPOluqnjrxKM0CCnFyInevAaygpFkpGxjfgfHkx/u+yb39FqmfPviiijAb2L+MhRV4bv5qZiqsyXlm6Sw62YIHPVUyi4pyLoK8FLoGEE50F/X94Fgk4Lqqo4G9dWrtKlkpO0K4PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HslXKlml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HslXKlml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD4EC4CED2;
	Wed,  2 Oct 2024 13:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877215;
	bh=ZRKdWTXOR/o/oCaJnYTqkyGztRN8qWnG5J1DaeGxemU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HslXKlmlkLWJbnHIN/v3Y9qGDdvp3YeTYmzkcVw1aRz+Hmnl+H7U7d4SWWFwSgDuN
	 3G3XcV3dMdcdRodcdiTN+vTF9Vm0i6RyPSjTdU75da3OXyZI2nG8BxHOSVWAnKSAs/
	 vPiQv6UfuiSFOZWGu5yHJG4+MHYw4eBE2S/JGt14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.11 692/695] i2c: isch: Add missed else
Date: Wed,  2 Oct 2024 15:01:30 +0200
Message-ID: <20241002125850.142905523@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 1db4da55070d6a2754efeb3743f5312fc32f5961 upstream.

In accordance with the existing comment and code analysis
it is quite likely that there is a missed 'else' when adapter
times out. Add it.

Fixes: 5bc1200852c3 ("i2c: Add Intel SCH SMBus support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: <stable@vger.kernel.org> # v2.6.27+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-isch.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-isch.c
+++ b/drivers/i2c/busses/i2c-isch.c
@@ -99,8 +99,7 @@ static int sch_transaction(void)
 	if (retries > MAX_RETRIES) {
 		dev_err(&sch_adapter.dev, "SMBus Timeout!\n");
 		result = -ETIMEDOUT;
-	}
-	if (temp & 0x04) {
+	} else if (temp & 0x04) {
 		result = -EIO;
 		dev_dbg(&sch_adapter.dev, "Bus collision! SMBus may be "
 			"locked until next hard reset. (sorry!)\n");


