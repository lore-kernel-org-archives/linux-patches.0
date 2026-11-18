Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015606;
	b=hvJjpGK+m44SfbMTQglE2cmDn7bC3jD5c0Y9mQFBCf3Oj373VA47aVvkrMuKzgHSzpxs
	 g2RdKWvdLEDnBsHg0U6aDtjFck9Tq93F78RyqRRJdZRn07ocRKOnwGNdynaKI+8WFdql9
	 YbcE6XaRcwNsE5Hwf7gsmAv2ZkHR9kWJlBEEdMXT+iCDfh010kU3pdXB62RsaRP1ReAWI
	 a36+yjdFO9SeInQLVrRqHCld2YAr8YBOGJ71if3XJnapWT9DJ5kC1Hf0dwMOqBaxngE2Q
	 QuSvrqer9NE0OZogy/r5GiJZrW/XtyR6HDtdK8dCSvKFAKV7YEWXElJHhdgtD4KHyiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X8hBPv44C7lBHiA+6CRY3cuf3KrKwrd3uU3qrdfJaVo=;
	b=lLaixVAQU0A9L9H5zcqPh2HJITqq+hbyLCLnFD21LINmTXacggFnJ9WXP3CJTkTvXgzp
	 oqaD3RKIzYyYv3vZryYK32+P7KtvWk4fspDIW/sHA+ewdehopQyGgEyE3yuxlj+L0mo6R
	 hGgSekiPztp9wDJwftiMHfgvhZVbP+8GMH9zrS0LzaGbDNuCpVuQdfg7YUEmFTzb0WEeC
	 QogSvmGTKp3GsdU/C1iIAlYrxjSAiyjwrG7JF7YZ5TlR9TFf9JucqVQ9z8TZzv1ybvcjB
	 IrowmgUMNdDOloTraLGDxzPGhA9OJWsVEtSA1f8JTj2POBOhh7bUI2xghrfuRI5yzbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pAJIDuhg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F36606A32A;
	Wed, 18 Nov 2026 15:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pAJIDuhg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1166D1F000C4;
	Wed, 18 Nov 2026 15:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015606;
	bh=X8hBPv44C7lBHiA+6CRY3cuf3KrKwrd3uU3qrdfJaVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pAJIDuhg81atuFan2Mxqc3mDXqs7qAF01HE1MrxZCjVA960pohF7eCPCsU8BeP+Mt
	 sMY361edpqKMiLbSA5NetX3HfCEHxeA1qdNulFXc6CHpxJ7LfRr+FCMlxWXMj7rcOl
	 iysX/a0eU0tQ814sP7lERLRexCpEoJHo2/1sEa8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Dolan <paul.dolan.dev@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0206/2651] selftests/pidfd: fix PPID values in error message
Date: Wed, 18 Nov 2026 15:24:06 +0100
Message-ID: <20261118150255.290185043@linuxfoundation.org>
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
index 318e6f09c8e0b..c6698b7cdb479 100644
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



