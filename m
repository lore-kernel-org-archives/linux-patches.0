Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023032;
	b=CX5NVoQoo5kOmdyuJU3FIP3KfMy6F01tdY38HCGglF6dFjs75MTmsdGQkaqoCMhZjzkh
	 hAFVDt2+9Fk1bTCwDAzBM+fo/COwWuy2jxhU0mXIcF2xVlsnwioaazUd6b1+PJ3g1R5bn
	 fUjBIz2a99MUAbGLZmPem6TWQVdvS0INdDwsA+NdVfEVqpOWsd6/YqpYM9jhntdFRzZEf
	 1uydWh7VpzurJHyQP+aDnb7nJmrfhbzpwmfy+9/UeCVbIW48EP0R11F2IVRhXca8NpNl7
	 IUwAd1Uuhvw/LmMz0lO7fuCsMBjp468wzbXdMaGGl0omSW1nd4k07rwDNF7CMZvR38A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gQ8r2odnNY8K+zEvlDnxkKzLWJ55X+rwbN9CPwyOYUs=;
	b=K4h55HPLjqfSUUcqXNTv8YSRv5eD+KjX/7WVhrHX+JJ+QLdQCXK7UXoRKpcH/EfqfPkE
	 ZcA1W0z+giGY5txuKLR+eJxB+V2pLQB1GMeoUh9KzYhO7aLDCmYb5yXcrnCBZPJc1nJh5
	 rxgVGjgiFnJQJm9bO2DZ1IC3dMMP9xyFif4hPjVzSjHWbJ7aTRPvNphJVYjMiE6mWy0ZP
	 6WecV1I/8BqaX+QkpYGkb5itcstMPGizdu1R+SCZ4TTnchF5vl8Uv5XIJEMjau3RYpKkX
	 UlLYKUGQgGVDhTIUGkih/ckuXp6vtzXPaeEt9ryjrGqYJKqAHobNw6aV6ElLZUfLmPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iXvuGZ0O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED882606A335;
	Wed, 18 Nov 2026 17:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iXvuGZ0O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0F31F000C6;
	Wed, 18 Nov 2026 17:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023031;
	bh=gQ8r2odnNY8K+zEvlDnxkKzLWJ55X+rwbN9CPwyOYUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXvuGZ0O5eO2icGQQ7TMkHwWWV/KYpxDN2GDI910YhPNUnp0dyKXidUx4F2TDJZF2
	 NTCvl5I0lNO1t/8qyYaSdXhEvt2Qv/n8X/sRvpVIdeIKRti9UEN2jMxuSN+W1MUZDi
	 QiLg41vByxOhbLjDHXxcY11Frjd+7Jh4/zx0ytuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Dolan <paul.dolan.dev@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0223/2151] selftests/pidfd: fix PPID values in error message
Date: Wed, 18 Nov 2026 15:32:38 +0100
Message-ID: <20261118150129.908796590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Paul Dolan <paul.dolan.dev@gmail.com>

[ Upstream commit b4ad6eb49532a43ad06c4d59ec5d8c80a012eb3f ]

The PIDFD_GET_INFO PPID check compares info.ppid against getppid(), but
its failure message prints pid and info.pid from the preceding PID
check.

Print the PPID values being compared so that a failure reports the
correct information.

Fixes: cdda1f26e74b ("pidfd: add ioctl to retrieve pid info")
Signed-off-by: Paul Dolan <paul.dolan.dev@gmail.com>
Link: https://patch.msgid.link/20260902162615.11531-1-paul.dolan.dev@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/pidfd/pidfd_open_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/pidfd/pidfd_open_test.c b/tools/testing/selftests/pidfd/pidfd_open_test.c
index cd3de40e49771..ffa4443c48538 100644
--- a/tools/testing/selftests/pidfd/pidfd_open_test.c
+++ b/tools/testing/selftests/pidfd/pidfd_open_test.c
@@ -168,7 +168,7 @@ int main(int argc, char **argv)
 	}
 	if (info.ppid != getppid()) {
 		ksft_print_msg("ppid %d does not match ppid from ioctl %d\n",
-			       pid, info.pid);
+			       getppid(), info.ppid);
 		goto on_error;
 	}
 	if (info.ruid != getuid()) {
-- 
2.53.0



