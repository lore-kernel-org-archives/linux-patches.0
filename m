Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774366;
	b=KYiAvS94FrdK18MWxKKmHFLylADAY6ShxqNCqtDm2xFz/jBj/TTJ61GGuN+YUPQrhYos
	 kD5m1gHUswrXbq6M6bdxhmSSLusy/rXGF/u3bqDwGsgdaDPH6aS+WLtOFkzrAVsYcc25m
	 xile0lG6lMVRInAPUtQ7kd87RMSpG7tuYSUsepxkofhzSejx7iilR76f0C8VO7YpTt7GE
	 7fvUe/031b1+HWZV5lSikneq+KFbMKtD/FjSXz0w4OCwzOAzn/J7/BdEFCIKMIw1S0f+G
	 UOWv6qEr9d0kxnLsquubR+NmU5uMFszEtAyxYMrSpNQbXHwDeZ9dAR3X3B+2nUbRS1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+iYfjLpamjiDzpG7JPc7F+5lANgU9CCskqX16A67wgk=;
	b=0pIkfQsNkUnr13s01Np/7IErsYj2nezwH2DEkAoG9xT6qaA9fjyRystE7eYfQRKrTgEg
	 nuQV/txpPRgT9Rm/9iv2qSI+1F8tVYuJZiI4juUDZLppRH6Urv0b2BoyKkfD20EPPmIL3
	 5guI5tiMCutn6yRGSpnVJz+tq492r+aRMEKLC2cGx9YJFTgt7rXHwOdLrpaCSfxYagvli
	 gVVKo0pM5dUKFmsFKOdjzRVgZ4cKV6yPelkNh/2H5L0WTpq3YIn5uAQXa45rqPtuILHR7
	 hurb28un/iR5Db1PJWD/mt9TK++w9ptUA9Vnlv4vLrEj9bV0txZYsNr34RdVNxGdFCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hg93dHNH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8332606A31D;
	Fri, 23 Oct 2026 16:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hg93dHNH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82521F01825;
	Fri, 23 Oct 2026 16:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774365;
	bh=+iYfjLpamjiDzpG7JPc7F+5lANgU9CCskqX16A67wgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hg93dHNHCKDpM0HenThsUdQN0MpCVFfRl0TuIjezgANORf3p04j7rC5oeCQKECeWV
	 7mznpvaboCk7Kd7lHuIkqFWfbITMHlI54biPv1FTBf3faav71YGVBds1An6w3aVt7d
	 0xUNa/c2c8P0kiP57LQNgT+K02zFse/WyA941HOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 017/242] tools/power turbostat: Warn, but dont Err on out-dated perf systems
Date: Fri, 23 Oct 2026 18:37:39 +0200
Message-ID: <20261023163714.195365965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 1de8307e861759386057f8683bdf0594b2c803f0 ]

Some systems in the field have perf enabled,
but their kernel perf support lacks the latest L2 stats.
Warn, but don't Err on those systems, and suggest how to avoid the Warn.

Fixes: dd23bfe4c317 ("tools/power turbostat: Add L2 cache statistics")
Reported-by: David Arcari <darcari@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 920694c3c1ec9..6d3a58df678dc 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -9471,8 +9471,10 @@ void perf_l2_init(void)
 				free_fd_l2_percpu();
 				return;
 			}
-		} else
-			err(-1, "%s: cpu%d: type %d", __func__, cpu, cpus[cpu].type);
+		} else {
+			warn("%s: cpu%d: type %d: Update kernel perf support or use \"--hide L2MRPS,L2%%hit\" or \"--hide cache\" or \"--no-perf\"", __func__, cpu, cpus[cpu].type);
+			return;
+		}
 	}
 	BIC_PRESENT(BIC_L2_MRPS);
 	BIC_PRESENT(BIC_L2_HIT);
-- 
2.53.0



