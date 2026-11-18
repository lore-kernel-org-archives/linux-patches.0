Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015732;
	b=gdozEuqazcLzoSI627OwY53HlFcsUb5dNiJhQuacaYEmYIk6OfAiNWRxIfo0lue+vGJE
	 0Emf8p7kQKQPlYSq+A/iFTpEEkr+QZmzfTa45KPRIZxV93iajBI6YEZ50TziF/x7QkZgi
	 dZEgHpMClwNTZ6pgndm3puqTb/th406MBvB+FZeUAyU1SIwVQnQa8SS5tZJeyrBtyuFnO
	 2AWyhrVXBTjGXzgDP4TGoISmIaHd/xZgnvL5clcq2ntFKwiGrud4H0d7z0ONoOGvt1ji+
	 nbS3LuuKnBN2efMWD4cCt9bqd+Bu+wfNkluS8FDJ3PG+dQTclVnFuyWR231VLgwJiqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uqGXyNn0vNsc8qoP5JndumfXdXQXTKWG6a6HZPbhM7s=;
	b=bTZT4dsubSw3c/dYLbm3dVpG6slN7hzIn+TwicgAMTEgRRiFfrejSqnXWXONnxh//Mvk
	 odELmd7mpRia+2482irgn6LJWFYNeSdzk3XoKOX8CfuSmXE4s5sR8h3QLXMGRTxG0Ua4z
	 hROQJGBYUGcJPvUDsrMXZQqXmQG7gkdmCpcedzn6I47TgWQ8Eji97uQoR2v/eYHggCFJE
	 1SJ31tMIjMqEXO8Ezqvx7TgT6dWG2apcbKPaPsLDbBHmLLgmrISr1MyNYwMsc6Ihgyalr
	 UFvzyf1ngBh4ECwcr0cTXTTECKG00G+e8U6ZGxI56KfzLb+FswHYZLyRxvNvrNn/PCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FzzQUcmE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B95606A331;
	Wed, 18 Nov 2026 15:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FzzQUcmE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C802E1F000C4;
	Wed, 18 Nov 2026 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015732;
	bh=uqGXyNn0vNsc8qoP5JndumfXdXQXTKWG6a6HZPbhM7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FzzQUcmEwzZGrzjKd9NT73CIVLwtvxTXK4U0OqiJmMzje5zcHknUb8VKrtmVaH2Nb
	 edCK14o53gO4xSc/oxh+Gx4Pw7OPex1bV6qUfr7HBPBctmj/9ujNVwPk7iyScUC/a0
	 jmSzAH7icgyJ9gUoZw1n9Z9tyjpWb+a4TKOwmAvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Chen <hi@tychen.cc>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0277/2651] selftests/sched_ext: Fail interrupted test runs
Date: Wed, 18 Nov 2026 15:25:17 +0100
Message-ID: <20261118150257.885363171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianyi Chen <hi@tychen.cc>

[ Upstream commit 7036264dcd46ab641768ef97ab74f91bce5701c8 ]

SIGINT and SIGTERM set exit_req, causing the runner to stop before
executing the remaining tests. However, the exit status only reflects
the number of failed tests, so an interrupted run returns success when
none of the completed tests failed.

Include exit_req in the failure condition so callers can distinguish
an interrupted run from a successful run. Keep the result counts
limited to the tests that actually ran.

Tested the actual runner under GDB, delivering each signal before the
first test and after the example test passed. The original runner
returns 0 in all four cases; the fixed runner returns 1. Normal -h,
-l and -t example invocations still return 0.

Fixes: 9d851afa4826 ("selftests/sched_ext: Abort test loop on signal")
Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sched_ext/runner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/sched_ext/runner.c b/tools/testing/selftests/sched_ext/runner.c
index c264807caa91e..57dda75384f16 100644
--- a/tools/testing/selftests/sched_ext/runner.c
+++ b/tools/testing/selftests/sched_ext/runner.c
@@ -243,7 +243,7 @@ int main(int argc, char **argv)
 			printf("  - %s\n", failed_tests[i]);
 	}
 
-	return failed > 0 ? 1 : 0;
+	return failed > 0 || exit_req ? 1 : 0;
 }
 
 void scx_test_register(struct scx_test *test)
-- 
2.53.0



