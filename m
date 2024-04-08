Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F3F1272D6;
	Mon,  8 Apr 2024 13:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581856; cv=none; b=HI9gPsmva0AAGqpSzlIvyGxafUJkvTu7mj2SzAvFVGW0KYXr5fZe/ETZuiZwBsTKKjDgS9msw2LbNux3QS2LKHgSOLqmNFAR1Lfb/Zzrp+wy5dedQca5nWS7zEfdRHbCPXEn9jnNOWXmRPaiFirfoIiOisNdRXfEfCSzDOCz5HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581856; c=relaxed/simple;
	bh=qpPqxoyyop9/TgRDJxJIRa9MCjNMbJ/3feA5MjqIKK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHvJm864Aonobljev8drhykYzVwzg6ItV45yDYursKUZh96VO7HwsKgFqxAmsH6VcOj2eCABDJuQu0Y4T07LUQLW5TijxyPwNyGyfkdj8Hjm6HWR8q9ELlkosklnvgVK2rK0r4zbmyLJnvnMlEwKHB7J2pwHQddeMp+U3kNb1Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whxgvxxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whxgvxxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A61DC433F1;
	Mon,  8 Apr 2024 13:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581855;
	bh=qpPqxoyyop9/TgRDJxJIRa9MCjNMbJ/3feA5MjqIKK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=whxgvxxv+5iLaDKYwZVlQ77CiryhA1EkiXxiB/n81h1t2kedCVUvPxqEHoa09i5p6
	 WvikFnaBvQ68rEwyBTwz1ljSAed1HMX63EhxvWG/o5oB14410RHdtRPavFuQnN+VZ3
	 APfuuAGjbP4na9/N6wKC66Zh8WFuAbFy1cqX+GmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 057/138] selftests: reuseaddr_conflict: add missing new line at the end of the output
Date: Mon,  8 Apr 2024 14:57:51 +0200
Message-ID: <20240408125257.996052111@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

commit 31974122cfdeaf56abc18d8ab740d580d9833e90 upstream.

The netdev CI runs in a VM and captures serial, so stdout and
stderr get combined. Because there's a missing new line in
stderr the test ends up corrupting KTAP:

  # Successok 1 selftests: net: reuseaddr_conflict

which should have been:

  # Success
  ok 1 selftests: net: reuseaddr_conflict

Fixes: 422d8dc6fd3a ("selftest: add a reuseaddr test")
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/r/20240329160559.249476-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/reuseaddr_conflict.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/reuseaddr_conflict.c
+++ b/tools/testing/selftests/net/reuseaddr_conflict.c
@@ -109,6 +109,6 @@ int main(void)
 	fd1 = open_port(0, 1);
 	if (fd1 >= 0)
 		error(1, 0, "Was allowed to create an ipv4 reuseport on an already bound non-reuseport socket with no ipv6");
-	fprintf(stderr, "Success");
+	fprintf(stderr, "Success\n");
 	return 0;
 }


