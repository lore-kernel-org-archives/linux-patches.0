Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025312;
	b=KpjV+WdyU71MdgGYWoKQ6XIeFqfrcVjTEC0fEUIiNfrXWSi7KXMa8XAsM/pbxEk0dUGz
	 IJQcUukq+i95PFg++iUR0JUKX7rcsM44oCpqgvSkbi/qyP9j9pTU9xi98ITwbh0yv5jgu
	 0mx25aQDQfm2z5sSlICesAq0i4YEcyX5WjyC+EZ/gvhVALkHvvq8HB+kFDgYWIS6WvYXb
	 BTS3OYHPDbMhdlggE06Yfr00ALfQk6fqekTZgYdYvepJpUqi3+s8U3wveqbJ9ulqthttr
	 MmmKIP0B1dPrsLYdmk+AHDAQuhXATNemF49E4V70FUh08HauP83fhKQLT99OZa2/9KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IfQQsMUEhn7aMzXLz0TXCirUtVF2qh8M9/mmf1wiHZQ=;
	b=rCGoIYisdRY0PfeBfAyezNVVn7a9BciCOzPpDYtTgxuMeIda//uTtD6zlx9Lc9Rbn5ev
	 EEqvh4hUMwmuI2JtLJ2mJicfVdvM253XVxzv7DKO3reBQtbK9jKXt+LZtq5L8xo8A/+OS
	 2Jbkqv4PBQe18p1nPJ0wBiz8dnztfaCMDYSADyo+HfVIYKYGuAJE+5lKmByWKKuajL0OR
	 5tz7LIgv3mnnGRfM6WQt23T4Q149htf3geSSNMnROYMaajABuklrwKd63ZUsL9lo9IsqR
	 4q3m294EpHW85frG0CkifbMfaZ0NRKIAMKfv26TFchwMbZ9ABgc8IQU5Zk9iNHUuNCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XlJpLZBG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0730606A31C;
	Wed, 18 Nov 2026 18:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XlJpLZBG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154051F000C5;
	Wed, 18 Nov 2026 18:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025312;
	bh=IfQQsMUEhn7aMzXLz0TXCirUtVF2qh8M9/mmf1wiHZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XlJpLZBGg80asNxFf1OOqAnhmQ04FPbaE237kQDDn8slE6zPxWZqos0G7TztOE9ZS
	 IyiAJbKWzT07nhC41iD7IJADOGyBtw3PaFk/tqYWS6F04hwpq3JoW0FuS09sjYpf9g
	 8BlngNGH8JEf12C02hBrH/42fv8bTd2e+HaU7yRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1036/2151] .gitignore: drop Module.markers
Date: Wed, 18 Nov 2026 15:46:11 +0100
Message-ID: <20261118150200.093718944@linuxfoundation.org>
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
index 86a1ba0d90353..90bc8632f555b 100644
--- a/.gitignore
+++ b/.gitignore
@@ -70,7 +70,6 @@ modules.order
 /vmlinux-gdb.py
 /vmlinuz
 /System.map
-/Module.markers
 /modules.builtin
 /modules.builtin.modinfo
 /modules.builtin.ranges
-- 
2.53.0



