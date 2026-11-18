Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045007;
	b=G7odaQm73QNEE82MAgTCIPsXHdswMkwa+fN4uA1zi8ogD3lzhEioKHRr96YE5XDtdml3
	 C5sWu0770eQygU5wEHNSf5/9ZYZUKILUUmln0B19PvRRzz02vPlDrtx+pf72VlxReC1mU
	 GMHygh2prFl7el0UPPlwJ4Ye2+KDma9xKHeY1Iox/eDtP3G9kusOuZ+2Euc1fQKDdfa39
	 JeLBgFeMvVOm+P9y7T7uN12EuvmFu4D7Gp5K7g1rR0+YKoQsA2ccKFqUtk/5+kNlCbcVE
	 dHVbuVlBa8259hmXlZ9WepQg6TEnbQtV7xcsJeDo8YReyom1wjUNKaDDg07Ye27FfNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t/CoZSBYEJpBzjyGE5jUKnaj3tfevE9mL1vkviIGL10=;
	b=2uivioIri8gXvZvu387BRXoKUzuOc5J+UbNdmNAYRAPfMzg8M0bINH6l9uL7754DRhpn
	 Myo4pDRMeRJUzTdZlN+CXh9klZTTbkxffUzP63kmiTRGbCGG0EDz5GCgzzmHk+385FO6Z
	 qDtL7vQfU2wtehDZt6r68HGiRmtt/VAggRApujYMjmWHL+3xRLQC47aL6EYNhI4WV78/M
	 +TXd2u9T8BT9W7r5AgsybzoCYMgX5izgLEHbCTItXBez8rRqii7h6uUcHUEIy3CiSZZKi
	 WXXazzonOFoE1g5VX3DvyaakyztJs2Z6vKNgyCiOMJD1IzAJX6kzH2nFnzko23YqizA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R50MT9fG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AA1606A320;
	Wed, 18 Nov 2026 23:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R50MT9fG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E803F1F000C5;
	Wed, 18 Nov 2026 23:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045007;
	bh=t/CoZSBYEJpBzjyGE5jUKnaj3tfevE9mL1vkviIGL10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R50MT9fGYx5a4vTheZTDR8oQK/Q0HO2+1evk9Dtj1Uhd157iBSyReMnf3kl3yyeQK
	 hxKZDxh9SXJUSBcbWMOBdGyaZWym5/cQh+QS/DWtsBuMzn3LVyTBOJrZJTC7sIvehG
	 B9RKf0piiNivFbcVNEfYJkv2uPJPtMaOVFjxiPS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0733/2857] thermal: intel: powerclamp: Reject invalid window_size values
Date: Wed, 18 Nov 2026 15:29:27 +0100
Message-ID: <20261118150227.942232285@linuxfoundation.org>
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
index 2f4cbfdf26a00..e89f8757a7d16 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -153,9 +153,10 @@ static int window_size_set(const char *arg, const struct kernel_param *kp)
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



