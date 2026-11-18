Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055656;
	b=qzoBSzx4BV6pzSHmslL61uYE4D5AqGDzVxevWAP67u7iOQ2hMQVmS4UZxwj7WCf7fQm8
	 y6YlMnLa8AQQj2d3ZisBCAlt9l4FkiehMV3lHYn2/pjuJAkvaK7OcydUnrVhG+A0kT1TH
	 D1CaDfezgoFSM0GDV91Lm7guHWXJErQBr21vRZLrpvzXl980RNo3qRjP/gqEEP0DrXJyO
	 TpUPVmIlgKhKbQWLGSw+q1WGa4Zwr5U3HEM1B1QDyjwzSXjw5kBFM0njJUYfxxohpRcha
	 h724yC9oVEyRfoLbADW2UfI3b4YjG+p/iQ5IB5HUyHhPGb9EwkKmmExKsQQWgC96/fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VmRH//FEHyifDNZytK314Uz9xOcJM6Q1VvaaSGP4H48=;
	b=Y+WtHTXtBZZLqZWiGGUJkcDeSV73JM+YH9VY2Wi4nCo9qol676OWRhWI9pz5gGtl1enQ
	 mN34cGnm6h4IOgXhDuMbySZ4CqNFvyJuu1VxaKtMBhT1AxWhcDcrCpKjY4ttqVR8FnkPs
	 4JuieiaoB4T3IMs+YG2ePoX2SSF3LqZP0R49Hz+LinneBZx4NtZG3OycjvBF7gKd7bd6S
	 myqI5U/oC7BwHC0qh/ejp4ByJhzilPgDqslC7qEO3Jmtv8mzj0Y3/8TH+Wr2tqDKm5Tvo
	 EL+GZ6K1UIcd7s25jP+3nrjUe6hjW9MvtI/yo597M4r1iOfiI3FQQb8u06o7JdUPinA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FTXIyXJK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A73A606A31C;
	Thu, 19 Nov 2026 02:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FTXIyXJK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9009E1F000C4;
	Thu, 19 Nov 2026 02:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055656;
	bh=VmRH//FEHyifDNZytK314Uz9xOcJM6Q1VvaaSGP4H48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FTXIyXJKdcanRrk/39KYTPH9Ff3n3CRNAfu+hC0RqSravj6Q2akSSQUUYye+tb90k
	 gR1iqhJQKuV8VHV4ZNODwmQk9Q3W4dgnkBMQqzDTZGPR2e1nYok0JjRmrqrYBTo3Uw
	 b3IVsLBl1pegerlwePiiHZxJzfoQ2YvRQS99XmUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Nicolas Schier <n.schier@fritz.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1682/2214] kconfig: tests: Provide defconfig outfile for savedefconfig
Date: Wed, 18 Nov 2026 15:55:58 +0100
Message-ID: <20261118150119.117207668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Schier <n.schier@fritz.com>

[ Upstream commit 09bd92ba15bd00d937deea38a10a439458393043 ]

Let kconfig test framework's 'savedefconfig' forward the requested
output 'defconfig' filename to 'conf'.

The original implementation was calling 'conf' with '--savedefconfig'
but missed the mandatory filename for the defconfig output file.

While at it, honour the 'dot_config' argument which points to the input
config file.

Fixes: 022a4bf6b59d ("kconfig: tests: add framework for Kconfig unit testing")
Reviewed-by: Julian Braha <julianbraha@gmail.com>
Signed-off-by: Nicolas Schier <n.schier@fritz.com>
Link: https://patch.msgid.link/20260929-kconfig-tests-minor-updates-v2-2-c5902bee1d0c@fritz.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/tests/conftest.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/tests/conftest.py b/scripts/kconfig/tests/conftest.py
index 3d75025437a70..0bc635f840a9e 100644
--- a/scripts/kconfig/tests/conftest.py
+++ b/scripts/kconfig/tests/conftest.py
@@ -209,7 +209,8 @@ class Conf:
         dot_config: .config file for input
         returncode: exit status of the Kconfig executable
         """
-        return self._run_conf('--savedefconfig', out_file='defconfig')
+        return self._run_conf('--savedefconfig={}'.format(out_file),
+                              dot_config=dot_config, out_file='defconfig')
 
     def listnewconfig(self, dot_config=None):
         """Run listnewconfig.
-- 
2.53.0



