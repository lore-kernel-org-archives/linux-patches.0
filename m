Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030747;
	b=cDHWEqsiJrTTe/hdjZxTkFzCVFzalBoQfJpnVg0ch8gZ6R6MeyEhMgt1OHFhFnhvok1X
	 RbaS6dBkf4ONTrty4puUAY1EVPhFv+yE8C4kRk+/ycnt5BNozwG3bk/PfqW/5vzCAMons
	 h5noBvbXDED50xiSHKByfDewrTvooh+Xaz8yl8Pc7w8Sbymi2v5YeaOO2lY+SutbCLAgO
	 FQCqw8iemwOvkZqHZUDuLVgHVVtRT2FofIxBK4ncIEfF8AFsay3sGyAhWFJSAdwNg/Td/
	 IGu9FmrleLwAKVWVZXQhZyVi4hZQnX38ia92S+u/x2dECQEoGDXfNwrqehK31jWXqdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W1bMPjf8cWKiviOsgEsjwnhkq6Xa+gzAr+NTFw6wceQ=;
	b=ocKScJRcXObDQa2jPTwdSclnHudYebVDyFO8mCg+t7iXkWFe5IHROpmCJerjKhpKm8Op
	 ggJcxhnsbz9l6UAVr48ccoASEcrj3U7vTwl9LdSrWD1UbKUt+snjOXUzXDlaMpirKCxJ9
	 MvUvgECnoEjrwtouVt0wfM5BcS+0Y1J2EVgsAPLRVvc5OUwVZ7yxZy5e3LKgG830e4BxR
	 1L6YxSu2T8yfWivnl0JivFPZofIm0wJbmnmWTGJjuaD4Y4/AS6hHXnYQ4aDW4x5wgOXy7
	 4LSFOIJiZtCbzYXnB8/792JJtNj1+3AyktK+y0ObLxQR4XQKiBL0QjG7OaczM4kyang==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sqBcXJ9l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3984606A33F;
	Wed, 18 Nov 2026 19:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sqBcXJ9l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A761F000C5;
	Wed, 18 Nov 2026 19:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030747;
	bh=W1bMPjf8cWKiviOsgEsjwnhkq6Xa+gzAr+NTFw6wceQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sqBcXJ9lhAOAH7hLKrVnX1aZSunumcBEsxhsM6vNguCC0FGkXOGsfDqpOoB+UDY+Z
	 AsbjNSkY0PJ0BSRwdNNCL4QZoc5yBKIqXbamipmngoVEYLFMuKiritVOhY8sYRmevr
	 +NlQJ8G4/kK/6wEGiwBxikDXnry84wgACAJC99Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0814/1756] .gitignore: drop Module.markers
Date: Wed, 18 Nov 2026 15:49:01 +0100
Message-ID: <20261118150042.005324909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Jan Stancek <jstancek@redhat.com>

[ Upstream commit a7d32fa14bc74d1786a2f0513b6f0815bd4be311 ]

commit fc5377668c3d ("tracing: Remove markers") deleted the marker code
and the modpost output. Follow-up commit 8723eaeff59a ("Kbuild: clean up
marker") removed it from clean and mrproper targets. Both are from 2009,
so the file is hopefully no longer in anyone's tree, drop it from
.gitignore as well.

Fixes: 8723eaeff59a ("Kbuild: clean up marker")
Signed-off-by: Jan Stancek <jstancek@redhat.com>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/8cbe913b9f80dc6fea73a9e3d51429db2b38905f.1790838401.git.jstancek@redhat.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .gitignore | 1 -
 1 file changed, 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index a61e4778d011c..f94178a69e328 100644
--- a/.gitignore
+++ b/.gitignore
@@ -67,7 +67,6 @@ modules.order
 /vmlinux-gdb.py
 /vmlinuz
 /System.map
-/Module.markers
 /modules.builtin
 /modules.builtin.modinfo
 /modules.builtin.ranges
-- 
2.53.0



