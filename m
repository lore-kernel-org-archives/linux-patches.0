Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585457;
	b=UqdWI4mKgTcOu9BUTUZJtToOvLkF4h3FvZm1wDqzCMn3KH3xSjQTe36TrtVSLpv9uSdo
	 N8rmi5rnn7vDymbesCbqbhyuoXVMexaYQWkt0gnyTSjMySm5ifMIZHzp1m5x7ZpschTdK
	 5JJP+6bwUA4EPGZgOfWA/t/ibr1I/omi0/UaTV7MpWz2TXgC4N5+2IQ9OdMwSIHKCODtv
	 0oLPY7Q3dkFD0q+9xY4MXBJzBTc8iHhj/SBHOtMuUhyDAgrnp3Mfw7U+SzsmeqYxkCJVK
	 hhltcJXr1+lshFfWnBw74vxo6tx1bovZEdkVd3lpwMMxRJiOPR/md0Dw+BXwV7N+ItQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zQjYvEPZxQOCJrLumFApokmVQbk6IDXC7F04oGNr47U=;
	b=TidXgv+KgFpvds5Ui+bpAwiCyDWC0INK85+/y/Xff2n2QgIXSTVyxp8msJI7YF4GzErh
	 pdN8yd8vnzcto9Ts3k7ZpJ0J3U5aTGvf3G+SbpUL/xe7YiqyKE95xRHguGDshkx/fRyHH
	 JSL6o/y+2jN1BuSS+xPevwLvbYlqZmHzzW0bvzTF63VOP76ELR0RXscOjySYWKTlj6D7J
	 cOA1efcvtj4LHHmAi/M7ijZeCOa4KROFc8SsrHbteA9GkZkVt+0DnlmynF0SI3jZp6Xim
	 KrhrqH2d8dhsa591D0ZkQTFKRMCfc+vnkVIKbqpps7gPRMJDJC/xegvBZIwccMKlibg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IUDm8Hrd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A7560A6F46;
	Fri, 13 Nov 2026 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IUDm8Hrd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931E21F000C4;
	Fri, 13 Nov 2026 15:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585456;
	bh=zQjYvEPZxQOCJrLumFApokmVQbk6IDXC7F04oGNr47U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUDm8HrdDbuPeDYIxa7EFkMSEi+MuY/vHRZT6Y+3C4sebgU/azlKwbPfjqO6zMnuL
	 rBw/8USrlhwmuvY/9FoOUmsz16iPhpAKrkVNVMkto8DMhdmjbNfgVVOcU9mPuRA1OI
	 hc/3mgWA/OVAcFFppPAua1qwWiNdzYhOYsDT1sL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 115/507] rust: cpufreq: fix `undocumented_unsafe_blocks` in `PolicyCpu::from_cpu()`
Date: Fri, 13 Nov 2026 10:46:59 -0500
Message-ID: <20261113153758.238743102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index b75d692846a25..f31671129c984 100644
--- a/rust/kernel/cpufreq.rs
+++ b/rust/kernel/cpufreq.rs
@@ -696,8 +696,8 @@ fn clear_data<T: ForeignOwnable>(&mut self) -> Option<T> {
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



