Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042885;
	b=Qlhd6FvEo2jYZvYSbHUhqpghThdjBCpHdbKYK0I4Z33LWNJuctSS6fftxVUX0k0giHln
	 dgHxWbKvvjUO0GWPf3EZnU12zrKF7Zhcu3XMUreWa43xAL6B2VKDFKOiYCKdq5kaT4nG6
	 nFqc3EZpVjorT/C7JOCCBZ7dFukX0sne0gRAn1N7NlxLEobd+dP+asej3iTiDlEBjFRXQ
	 HrxsYWe/cgiQEtbxCDSBbRHWTxKLjmERH+ebnPkn7VHkq5cDk9l3TfBK+k+DGyk2rgEIS
	 wxgks2pHdquxS0/3S4FH+URUkKLtqxdf9QqFwds2xTDCPKf+JqKdCDlMiU6oPmFU2Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zZaxjleHrxqKl3ezk5WiWkL+9GOs3fo30fJWFuea0R4=;
	b=I9octgksnI8u6VxTmP+fKK396Qym1TA7oVeZnh11re55v/ebn9oSITIqMSNag1oV+U87
	 x7zgT3/AlYFU3+8b62T+mfH5EyKd68Qra/Bk8atL66gxD9z6PLcFZ3WdIhhvQJJ81FyN1
	 NlxjebYZfrO1DQfdCud1xUBtfC48FUBMM0hpBbonR50CW2BBFGlxi/gTaSvUMioqiJULz
	 jJuqOMWXTSOUowfFEBXGsRs465l5IU/RnJ8WcyVROutPUy8kuQVR3O0Qi+z07v0Qicdb3
	 Hxj5vZPBaOwgf1a97VYMfHjzyRvHcaKiq0ECUdPfo++HdtPzMsZfhal9ILleqgESjPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EO2a836r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD458606A320;
	Wed, 18 Nov 2026 23:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EO2a836r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162461F000C4;
	Wed, 18 Nov 2026 23:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042885;
	bh=zZaxjleHrxqKl3ezk5WiWkL+9GOs3fo30fJWFuea0R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EO2a836r9PvCvbOeADJy2BDf8U2/8iIdwk+QXf06vtYvqySbAHQGQcVYUsEYQ8xmm
	 WHX1F4jYg5eA6W4S3st3YHWJpcj84aFm+HchlLCMBAYTh4IBePE9ESkyUFpuc8HKw5
	 s4mlmlkDs1M0KAmua5Hv3ZW5Zf0fhJD2d/UQmlVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0007/2857] mm/damon/sysfs: put target pids for apply_inputs() failure
Date: Wed, 18 Nov 2026 15:17:21 +0100
Message-ID: <20261118150201.585103371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

damon_sysfs_build_ctx() invokes damon_sysfs_apply_inputs() for setting
damon_ctx object with user inputs.  If it is configured for virtual
address spaces monitoring, the setup also increases reference counts of
monitoring target pids.  If the setup is failed, damon_sysfs_build_ctx()
deallocates the damon_ctx object without decreasing the reference counts
of the pids.  If the failure happened after increasing reference counts
of pids, the pids can be leaked.

Fix the leaks by decreasing the pid reference counts before deallocating
the damon_ctx object.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260730040740.140836-1-sj@kernel.org

Fixes: 74bd8b7d2f8e ("mm/damon/sysfs: move targets setup code to a separated function")
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 4b28bb9ba0a24..b9b80d58e5bd6 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2515,6 +2515,7 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 
 	err = damon_sysfs_apply_inputs(ctx, sys_ctx);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return ERR_PTR(err);
 	}
-- 
2.53.0



