Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA3145BE4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNinfMEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B14CC433C9;
	Wed, 15 Nov 2023 22:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085832;
	bh=VF/9X/FQTurrAwXZHNZV0b13nRZYg60goZ3YsIoS/RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNinfMEyuE6O5aOng/kL1zgPIJLHv4okupnIkxRArJmpnR+JnrpYH3GUcsLG5RgQ0
	 x45cfUt1G7wWWEADd0b6/hbrjqLwLczyzEu6ENgkKA+NLwVI0eEvT9qhwhlZdvQpQL
	 d3huC3RAQTVZQ7jYam795n6/wXvERV781cmISJ6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/119] powerpc/imc-pmu: Use the correct spinlock initializer.
Date: Wed, 15 Nov 2023 17:01:14 -0500
Message-ID: <20231115220135.257198324@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 007240d59c11f87ac4f6cfc6a1d116630b6b634c ]

The macro __SPIN_LOCK_INITIALIZER() is implementation specific. Users
that desire to initialize a spinlock in a struct must use
__SPIN_LOCK_UNLOCKED().

Use __SPIN_LOCK_UNLOCKED() for the spinlock_t in imc_global_refc.

Fixes: 76d588dddc459 ("powerpc/imc-pmu: Fix use of mutex in IRQs disabled section")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230309134831.Nz12nqsU@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/imc-pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/imc-pmu.c b/arch/powerpc/perf/imc-pmu.c
index d42f2e091201a..872313021eaa8 100644
--- a/arch/powerpc/perf/imc-pmu.c
+++ b/arch/powerpc/perf/imc-pmu.c
@@ -50,7 +50,7 @@ static int trace_imc_mem_size;
  * core and trace-imc
  */
 static struct imc_pmu_ref imc_global_refc = {
-	.lock = __SPIN_LOCK_INITIALIZER(imc_global_refc.lock),
+	.lock = __SPIN_LOCK_UNLOCKED(imc_global_refc.lock),
 	.id = 0,
 	.refc = 0,
 };
-- 
2.42.0



