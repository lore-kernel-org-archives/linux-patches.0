Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217208;
	b=OFvvqiHnlLURUky80KH++cXC6S9T/Zw0il1JCzl39u/kvdnxF0sNTWuFlIkF3llqUKRW
	 5zqcr87H1MGNDUHEWJMyq3jB+Z8zfciLn7M1ztmy1MJaWOVOLP9nWHrw4YokYzkmpt1Km
	 uOPA3128NQG9jIjAgPOVzORQMYowabWQcDqgKholt/gmXbH+mSdYMqe3Kt/QFq69seT0u
	 wQuVfvhdsMbvLjOwlEZyia/FWJXXQCPz82rq1OltTrKmga7ZcjjrVNUpNUqGtJg7j8C6d
	 YUBZXcvNMIcjYVIOb+2S2hS1omDXMeO/jVeAqvGf+H9cLjJ+ARJDvQ3SALHxzYgr0ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qsldk/h697FXPql255ra2FsFsiEVzTzAjGLnIPnfgvw=;
	b=XEu26MkYvHgD0qHy4swVKwH/BbLvs9fcSaesWo3f+38lTMnNxVGuApq0x/fS881Xv7gh
	 RwAS/e1XMORDd70ecBUKtK2JUMYsFQW4aHGzHSHVFB6NSzghDG8eV3Sj02xs4RvSs6h5Y
	 uaYMjXmhvnaTkvpAewuUFrcRuMe9lgyCqR8Brct5kIgh3Z9yIIoT/5pKQlzeU+0aERD6q
	 9VIr+7IHdomZEdfT7QXBlOzF1pLSjq7kfCo8QPgNbL12weHkVV7Y8K2YLyIfQjZKvOalV
	 09gSMC2mAh0BSoeXJ9TEGeMVCnt3LAqaO1qetHQ23ktLz6ubc9HLYYgSV/r9TGg3bKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZK8gtZrQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A613606A31A;
	Wed, 28 Oct 2026 19:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZK8gtZrQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AFB1F01828;
	Wed, 28 Oct 2026 19:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217208;
	bh=Qsldk/h697FXPql255ra2FsFsiEVzTzAjGLnIPnfgvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZK8gtZrQtbpL7hFgxSWIYCyp980ZseL5x/llQs4hFYvTLoomxrKePsBF9DCkpNkHm
	 wV3hlI1nSvVcVDL5GTw4iae2wiFHQaDH03TA6UUp0TzrjJViAmSqwMUU+bgcUjCG3p
	 DEOAJUNA6nI6650OQG0Bc2ULBWluCo9D8pN8v+JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1823/1887] Documentation: networking: Add a caveat to nexthop_compat_mode sysctl
Date: Wed, 28 Oct 2026 18:05:19 +0100
Message-ID: <20261028170540.927551460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit bbe4b41259a3e255a16d795486d331c1670b4e75 ]

net.ipv4.nexthop_compat_mode was added when nexthop objects were added to
provide the view of nexthop objects through the usual lens of the route
UAPI. As nexthop objects evolved, the information provided through this
lens became incomplete. For example, details of resilient nexthop groups
are obviously omitted.

Now that 16-bit nexthop group weights are a thing, the 8-bit UAPI cannot
convey the >8-bit weight accurately. Instead of inventing workarounds for
an obsolete interface, just document the expectations of inaccuracy.

Fixes: b72a6a7ab957 ("net: nexthop: Increase weight to u16")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/b575e32399ccacd09079b2a218255164535123bd.1733740749.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 0a5ae93b44617..3fd6e0f0d3c96 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2000,6 +2000,12 @@ nexthop_compat_mode - BOOLEAN
 	understands the new API, this sysctl can be disabled to achieve full
 	performance benefits of the new API by disabling the nexthop expansion
 	and extraneous notifications.
+
+	Note that as a backward-compatible mode, dumping of modern features
+	might be incomplete or wrong. For example, resilient groups will not be
+	shown as such, but rather as just a list of next hops. Also weights that
+	do not fit into 8 bits will show incorrectly.
+
 	Default: true (backward compat mode)
 
 fib_notify_on_flag_change - INTEGER
-- 
2.53.0



