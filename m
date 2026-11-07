Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062763;
	b=HZB+iWppV5hIY2OeaM9BGlraBVDKlu7wXydoRqz0o/Yx6l4uOPjehZyDF+eFCRM51TYW
	 QZ4WuNSSEFSkxGTAcB+z8wdMTnTui+GofEyqMf+FhQtM9/gWzhcLDYxiJYAquZwXJKqiC
	 reyP4iJTKStCB97dHKfzytJGTIwgJSlPK/LIm0Vo7DIITEhUnA+80GAnkQPR9tUwN+ZuM
	 UqxThdCnyjPPwxTQi3SdKnley0lGoBJQ46jr3PLpiOGh0N71pF7vu0w74DjvNZllGq82R
	 Nt4iFjES2QmOZiEpWFNM+kOWKeiHclvOklxML+MMTLTCt3k6L2Esk2IZXGPhzkvNTnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q+Br1FigarMdTnbKKeMqUU4TQmlY+ooVA/4DAeNWCFk=;
	b=0zBhYixL/mruJFfCK3kjsWuwb6BJQDgYqJLiCg/pKjw52vtgA2gyLemuB7SXoNw9UJ/6
	 mI2PYzjsCrOEWcew6Fjh+pujUxDjMBcC2HV4wfF637OH1KKd0N2PEv3YI/UxY9D4U0Bct
	 iDXEb6CQjbCYa2v8ZrHmtRh92rlEf5KcvW4DhSk4Irm8fNHB0J3L54NfdA4AswQA/lRBe
	 w5aC6dYTfxcLjvnJNrkTn4JWuBf8lj8rRZUJCwxUzpZW3HGOHpXn2vjSY04Fzipgr4Qic
	 LmUpn9kz5pCLR7RsMqVmQnJjq+tlSk4CB9M+3G4yTNTf7P2i3cYdsLN58W9xujTtnuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tTLBI3wk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B72C606A32C;
	Sat,  7 Nov 2026 14:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tTLBI3wk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179411F0089F;
	Sat,  7 Nov 2026 14:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062763;
	bh=q+Br1FigarMdTnbKKeMqUU4TQmlY+ooVA/4DAeNWCFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTLBI3wkunZzEE/JaWXJncDUkZmGTOcJtS89c3jTSMkUGy1R9K0gbb6MH6Lp6gEF8
	 mhpC8/SF1vMMyyYzq8qmjqeu9QwGohSA1GRETPyzlf+YKVmPGmyZZ8+rqFZCxj30ST
	 hR00pLk0if02rmCQml1R1YmdIlfzDop15kyZrk18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/869] thermal: intel: powerclamp: Reject invalid window_size values
Date: Sat,  7 Nov 2026 08:45:55 -0500
Message-ID: <20261107134855.125277020@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 40989202104e498ff9adfb8c575d6cd159f13988 ]

window_size_set() sets ret to -EINVAL if new_window_size is outside the
valid range, but then falls through and still updates window_size to the
clamped value.

Return -EINVAL immediately and do not update window_size. Also drop the
now-redundant clamp() call.

Fixes: d6d71ee4a14a ("PM: Introduce Intel PowerClamp Driver")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20260815090136.88540-2-thorsten.blum@linux.dev
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/intel_powerclamp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/intel_powerclamp.c b/drivers/thermal/intel/intel_powerclamp.c
index 9a4cec0009106..61665f945b4c0 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -290,9 +290,10 @@ static int window_size_set(const char *arg, const struct kernel_param *kp)
 		pr_err("Out of recommended window size %lu, between 2-10\n",
 			new_window_size);
 		ret = -EINVAL;
+		goto exit_win;
 	}
 
-	window_size = clamp(new_window_size, 2ul, 10ul);
+	window_size = new_window_size;
 	smp_mb();
 
 exit_win:
-- 
2.53.0



