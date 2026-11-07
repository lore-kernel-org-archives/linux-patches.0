Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061921;
	b=Wwt7d8d15kz5Gw+dvKiKTLIOAnuSjabfjhk4QrPPyTefu9AxmWLCkt2sqANxvGweOC2z
	 sRlAUxa1rAaorWx0hq+sndDwXUSXfRw2R+76T4LbBzSZ4gmmFOOBOIaSu9NvbfbrSGWer
	 fwgZfs2yti81SH8gr/aCEshfaqbW5y/ccOciQVCUc/CYII9q1aNZ+t2ikU8+8DrCIR2B6
	 jL8PWXEKBWYXw1iToomJuY0wZisHMv7D6hJtCj31D6cNwm6MeQmCqZyJ+difK18TJQL2B
	 Md/LdQaCCByz1PLDGFUzfdWDcOq8Yupw+C1ukZmZZPf5E9LdeYbrFk+IhRFFoDBATzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bi5F/bgJe7hhosfWw0vxYbWiWcP1rTOGxvB4jr50Iyw=;
	b=YAzI6K1ek2sTehEofacLF8rQkpLJ5aSeun1RS/25fOV3ol7zIbYPOqnBA+NW8ooGleL/
	 wBbI5GVG0lVO0NxeSp5m6kuq7lmycMTkRZgGEJjRdjmyaEzM0Z+se8lq2hICmVJ8SzzBQ
	 zCrd5FFy2C5Ldxtx0a5GB+CfQg5aNEZo58Aad/kNRhDjGzim5HfJzXmgDNi2SkNcoJ3lU
	 OLclnEU4oXrq8sCUZT2ujmBmZDSc/C0pF+h24Pb2KPK1LvQD6ClwxsFlCmzRv2lNXoVvo
	 Vw7hbdP7W+Z3PTfCGuQXAxdA/bHav3LSmciJa1Mwh0rN/hrgxFF+enwP5JMi5XfVTvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IB9sVnzy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DF7606A335;
	Sat,  7 Nov 2026 14:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IB9sVnzy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0901F008A1;
	Sat,  7 Nov 2026 14:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061921;
	bh=bi5F/bgJe7hhosfWw0vxYbWiWcP1rTOGxvB4jr50Iyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IB9sVnzypoLtCbygVURqhvcrcStRzV/zvFHPR9PlIyPhFVk6pP4LVP6T4LAcHOSIl
	 goFri+i2eErxui/4Uewuy2UHGCu+qA0IAVKEXNlGpjux5zzLksGhVuNIBsTYlnne+Q
	 OuNwB1wWkBSukvYDDsCbSp4v7DZ+uBDi2TTsbR+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0927/1536] thermal: intel: powerclamp: Reject invalid window_size values
Date: Sat,  7 Nov 2026 08:49:03 -0500
Message-ID: <20261107135023.684547341@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 4ba649370aa1a..5a8a59d344e8f 100644
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



