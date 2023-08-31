Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1DE8F5D
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B7BC433C7;
	Thu, 31 Aug 2023 11:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693480205;
	bh=ihWBJ+6qKTKZDhEYuVhj3tNIT2HIl7RdlEZbKbXrx6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXqz6IKoIzl1KPdrqI3CcwI2HWzmMbPkX4BCgyLmdwly+1WX4TP6McMLzfrKrWPlv
	 W3LAtrsNWnYeDzCedRR/qtmM8mqmpIuLbcwaqZADq1fMNEcJiwXYOab6z5/AqffgTn
	 id1oE9hGMEUgDevc+KlO8XnW9qvAczg5KSqABAc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <natechancellor@gmail.com>,
	Ilie Halip <ilie.halip@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 1/3] powerpc/pmac/smp: Avoid unused-variable warnings
Date: Thu, 31 Aug 2023 13:09:55 +0200
Message-ID: <20230831110828.935770467@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230831110828.874071888@linuxfoundation.org>
References: <20230831110828.874071888@linuxfoundation.org>
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

From: Ilie Halip <ilie.halip@gmail.com>

commit 9451c79bc39e610882bdd12370f01af5004a3c4f upstream.

When building with ppc64_defconfig, the compiler reports
that these 2 variables are not used:
    warning: unused variable 'core99_l2_cache' [-Wunused-variable]
    warning: unused variable 'core99_l3_cache' [-Wunused-variable]

They are only used when CONFIG_PPC64 is not defined. Move
them into a section which does the same macro check.

Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Ilie Halip <ilie.halip@gmail.com>
[mpe: Move them into core99_init_caches() which is their only user]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190920153951.25762-1-ilie.halip@gmail.com
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/powermac/smp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -660,13 +660,13 @@ static void smp_core99_gpio_tb_freeze(in
 
 #endif /* !CONFIG_PPC64 */
 
-/* L2 and L3 cache settings to pass from CPU0 to CPU1 on G4 cpus */
-volatile static long int core99_l2_cache;
-volatile static long int core99_l3_cache;
-
 static void core99_init_caches(int cpu)
 {
 #ifndef CONFIG_PPC64
+	/* L2 and L3 cache settings to pass from CPU0 to CPU1 on G4 cpus */
+	volatile static long int core99_l2_cache;
+	volatile static long int core99_l3_cache;
+
 	if (!cpu_has_feature(CPU_FTR_L2CR))
 		return;
 


