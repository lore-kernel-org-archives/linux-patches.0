Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590287;
	b=x4sAN+Om3TTieDGVgkYx1fjRIDVawroe0kpLrcl8JoBCXUQ2HAcs+EMsaGTy0nT14Oyo
	 Z0+5toLNesT1j1DrU0dk4SeUtQb0IgBhUwMwX4MCsKyXN5n/sNkpEn+0Xcqrqw7TqdhgW
	 r3ACiUsY/R5h9VuEzKulH/2VZ06KjIbKNAULEgo/Qb/JAq7EdYPGd+D8i1FH9IKELQ9SJ
	 ZDXHu6CUeRD6OouVFBHb6bqa/meG5noeWR3iFOE7G5ep4hdJh5oSqSGZImjpfi+uy7R4U
	 WFxYDzuU6Et6mNi9uPnAQDAx7aqEB2RergKqiiL6WHj1LRISrebQdW+C7isN151s6tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f2iYyh9mCmqHGIPeR5mS47V5b8lNbFHv2MVPms45Cr0=;
	b=PB4f2mN7aq+xMJCaerjqb30fwHQX6n6hx2N32eFVLDaRSdNxwDZ5sklecKmY8X+EB98N
	 bDoRYN8LpnIxN4ksS8+GvX/yFolq2N7CZcE/fr0QAccs3Fj7Qqv0oLHGUdW6Yt2aB9+Hb
	 CbcjhzXtGgtJRttBx+VxzEG2t0l5+TVF0+tEJsty9lytZyZiL7IhF7UvJFTGEQ36Z4Vzn
	 qQ1CCHzpu3pS7+00pessUddCfeuRvlJRNdkHyXx4fRi2JXiUf0PuK2aH7cwP7lSn9Vx60
	 CwTOMh743ctEGj5D9/fSRnVLFC+ZxBZ8tAo3KdU/bx+An0Zwb/axBYqb9evYe0VBPIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgUKSp6R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95ECB607A5D9;
	Fri, 13 Nov 2026 17:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgUKSp6R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B4D1F000C4;
	Fri, 13 Nov 2026 17:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590287;
	bh=f2iYyh9mCmqHGIPeR5mS47V5b8lNbFHv2MVPms45Cr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgUKSp6RJ3tPAnJdOWlr0/RNw5KNYRbrx9yVjfqqHupgy2BMfVMTDsOblfgsndNKQ
	 pq/R6kCBCwRravaF3e7OH4+GaQseQALBTPno/cNDw3Hvli+09ylFU6Xt0kiZmQa4Zv
	 HwmP4bn8UKoRpvvBzUek8Qg4GIK+5YV34rqzmZbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 235/686] rust: cpufreq: fix `undocumented_unsafe_blocks` in `PolicyCpu::from_cpu()`
Date: Fri, 13 Nov 2026 10:46:08 -0500
Message-ID: <20261113153829.005184078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 62a40c72905be262e9e10790008d505ed0be6c0f ]

For Rust <= 1.86, Clippy triggers after commit 02c5d7bfa872 ("rust:
cpufreq: reject NULL from cpufreq_cpu_get()"):

    warning: unsafe block missing a safety comment
       --> rust/kernel/cpufreq.rs:700:26
        |
    700 |             NonNull::new(unsafe { bindings::cpufreq_cpu_get(u32::from(cpu)) }).ok_or(ENODEV)?;
        |                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        |
        = help: consider adding a safety comment on the preceding line
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#undocumented_unsafe_blocks
        = note: requested on the command line with `-W clippy::undocumented-unsafe-blocks`

Thus clean it up.

Cc: stable@vger.kernel.org
Fixes: 02c5d7bfa872 ("rust: cpufreq: reject NULL from cpufreq_cpu_get()")
Assisted-by: LLM
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/20261018163719.81691-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/cpufreq.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/cpufreq.rs b/rust/kernel/cpufreq.rs
index be312f523ebec..dbd1ea1e9be79 100644
--- a/rust/kernel/cpufreq.rs
+++ b/rust/kernel/cpufreq.rs
@@ -695,8 +695,8 @@ fn clear_data<T: ForeignOwnable>(&mut self) -> Option<T> {
 impl<'a> PolicyCpu<'a> {
     fn from_cpu(cpu: CpuId) -> Result<Self> {
         // SAFETY: It is safe to call `cpufreq_cpu_get` for any valid CPU.
-        let ptr =
-            NonNull::new(unsafe { bindings::cpufreq_cpu_get(u32::from(cpu)) }).ok_or(ENODEV)?;
+        let ptr = unsafe { bindings::cpufreq_cpu_get(u32::from(cpu)) };
+        let ptr = NonNull::new(ptr).ok_or(ENODEV)?;
 
         Ok(Self(
             // SAFETY: `ptr` is non-NULL and `cpufreq_cpu_get()` took a reference on it, so it is
-- 
2.53.0



