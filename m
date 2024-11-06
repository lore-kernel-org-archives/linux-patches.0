Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268D91D416E;
	Wed,  6 Nov 2024 12:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895229; cv=none; b=hzPPcj5ljpaNa2Mp0MXmAw3BkO/iniLGCSGag2AAwZGq51DX78Vt6cwC2dWL5XzsXDnOIt4nJEQLGjSVF1lcHOdkJ4q22OAH20s8/KabyZHGfDMTY9ucAoeV0NAcglWDCFoPishuiHLhhI5B7Zp7p+N4m9GssHB/j3mBB6gn9MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895229; c=relaxed/simple;
	bh=1KW9zv7vfIXWCwOrpio73Ope/KWmFMcLTUlXf9TDSG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTJu3gBF89wuATUx4SGXCD2bH2x19SqjdIb5BVX+dh6zWhrS5B8Saki71LksR4d/g78ifGRJ38+qrgpqSjohaZNWFZlOImhMeqgkeY90iiSW/oNz0gx/QLd18/Dx76+UyskfuGgEezUR46RpBCVPvhEQF/zkjJOxKi/OH8vx2yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZMW0Z7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZMW0Z7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C49C4CECD;
	Wed,  6 Nov 2024 12:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895229;
	bh=1KW9zv7vfIXWCwOrpio73Ope/KWmFMcLTUlXf9TDSG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZMW0Z7+M7F8d+QGNP1D4Pfz5igrrw47GLJKljQ0jBpIxppvTjJDphw50vecXU3Sh
	 /nRe9q83MkwFSItsy5NoKCBE26HcKsVICUM9t7ryqsemXef+zr2SKwzX+PgSQp2ZGp
	 x51PqwZmn0047woMiZub4e1Jj+oldinyY9vrUX8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 4.19 130/350] i2c: isch: Add missed else
Date: Wed,  6 Nov 2024 13:00:58 +0100
Message-ID: <20241106120324.118565626@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -107,8 +107,7 @@ static int sch_transaction(void)
 	if (retries > MAX_RETRIES) {
 		dev_err(&sch_adapter.dev, "SMBus Timeout!\n");
 		result = -ETIMEDOUT;
-	}
-	if (temp & 0x04) {
+	} else if (temp & 0x04) {
 		result = -EIO;
 		dev_dbg(&sch_adapter.dev, "Bus collision! SMBus may be "
 			"locked until next hard reset. (sorry!)\n");


