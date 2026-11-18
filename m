Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020493;
	b=sQKC07NHx8n1ZKXNsiRY5XBxuYBRB5mobSjehkdR6req1/VgYMnfamUCeJttnwbb2QHH
	 xhM/NnWbzdExnllU8Nlmf2MBmD8poowasOxK5cAh76UP+RS75qp86D4ec6hMLwGRGSWpk
	 CO5XS+90iBFGDF0Vph+6ExNgC13nUDUmrHaX8f7OQz0z+AdK6CUYeVXHJIiaLR4POXVb7
	 xPrmeD0BWHRFaqdMyu99+diU/CISnw1CmfHAIq4jh/Jo7FbWdF71QYlkf4k9AjTI0Fsmq
	 s+DFvqVMZ1zZSx5M+FMqR3JHOuXsPj2pEqWpT0pxryaknor+u9wouobpsrcJzaxAcQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gBDQXghYHO7Hd+UCCT6+LEtHHfZEUyUno+NvbcoIDOc=;
	b=TKgqtzr5nB3CJFW1esTM0vL/kCDznV7FRS9WRCsfd/B9chE9jUFM8PTwALdqUK39UP53
	 E5WphlBOx6INi0A0cBsmCYA/10aRxlRwP4S0C9NjrCFz5STHEn45Vf2dCi5W+uW6Oqbw+
	 2z9vwV6nkIAZpZYuXcmFkNUfvfDeLKJM7UodW7dWQMUQROqSx3m7pAiI4ilhP8hZv8nQJ
	 aLAIYdxev79EUObFNp5stNiEkwNojnERq/0N9Ss9Ip68lqwaURLz1C6jemsp/CfO9VIU5
	 0QgFwcVH8IQw6tyl1dJkWddb7EP94lJY0qEveYMh9uTUWciz2HsnYbYhOdAym4j89DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cnzi0i0P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88965606A31C;
	Wed, 18 Nov 2026 16:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cnzi0i0P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24531F000C4;
	Wed, 18 Nov 2026 16:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020493;
	bh=gBDQXghYHO7Hd+UCCT6+LEtHHfZEUyUno+NvbcoIDOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cnzi0i0PHL3GT+isfd6kHF14A15A7ItOAdRGRRnG3ZXM78/rgFzxjZDgprrXf6SRJ
	 rqr3MfXBCuyPkU5nrgBZCOEYx8V5JzwCu5XFQ4ReG1sYkgUzXIIQVn4KqkSXcM2S+X
	 GYxgOdweh74c2+hSmhUMm8AIoeIzDbkhVGkD0/Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1930/2651] selftests/bpf: Report a failure to register the session key in test_progs
Date: Wed, 18 Nov 2026 15:52:50 +0100
Message-ID: <20261118150356.169595819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit 66fd5eb9da12ef4ed089ed1974160d07ff034a19 ]

test_progs adds the key that verifies signed programs to the session
keyring before it runs any test, and exits when that fails.

It exits with 255 without printing anything. pam_keyinit revokes the
session keyring on logout, so a test_progs started in the background
from an ssh session that has been closed since leaves nothing but an
empty log behind, with no hint of what went wrong.

Print the error before exiting.

Fixes: b720903e2b14 ("selftests/bpf: Enable signature verification for some lskel tests")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20261008-selftests-bpf-test-progs-session-key-v1-1-ec48e793639b@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 46eb201b96a38..168d84cf4eb76 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -2065,8 +2065,11 @@ int main(int argc, char **argv)
 	libbpf_set_print(libbpf_print_fn);
 	err = register_session_key((const char *)test_progs_verification_cert,
 				   test_progs_verification_cert_len);
-	if (err < 0)
+	if (err < 0) {
+		fprintf(stderr, "Failed to add libbpf_session_key to the session keyring: %s\n",
+			strerror(errno));
 		return err;
+	}
 
 	traffic_monitor_set_print(traffic_monitor_print_fn);
 
-- 
2.53.0



