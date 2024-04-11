Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2622EAE5;
	Thu, 11 Apr 2024 10:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829959; cv=none; b=KqN/HJxuA9o2JHRKyiFInhWmiuB3l+dZAKJQ5X1TcUGH8ZNJxGwL0vV/BvRtqR6SEiEAX3DTEIDSBMeBA1oy2JROJfZVoTsDg0nEKLxqMZFvRSBbECfhQilQ7/cIt7q87tOsTcUw/a72GXNCvBYFODqJCYbj7aiB/ZueVMl835o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829959; c=relaxed/simple;
	bh=1GPQuvpuZeKsxVoBFgufmPsbJgvCovTX9+pWjCBzPOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgA/AEk9dNna2AboQGy+2YRAeeNGs4U3teH6ca4CKcXNkrc8UB6Nh8nsRZTQL4wzsOAnNIpA0PJ34Gp5NlXDANY3WRSb6NFqXJdp8WWwVqLMy4i7ChemneZyRgZT++LQCk2NT4yvLuU+KGeEwebBeW3w4OE40O7ZMs3ZgnTf0k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAqAC0qk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAqAC0qk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC052C433C7;
	Thu, 11 Apr 2024 10:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829959;
	bh=1GPQuvpuZeKsxVoBFgufmPsbJgvCovTX9+pWjCBzPOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xAqAC0qk+33m0ga7xfkxF/SyAndEPF6JkAY7+8HQJGnKp6xhos6XCwxDJg7wv/3UE
	 VDREaZElyDWI3Tw7W95xT4IiR8PK/GxCdXnX5M0XTdbHLfeeruLSACSmkVP8uIOOoX
	 1pzSpaeVsgseLfWAnB9I2yoQK5J9mraSonnPR4uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 125/175] selftests: reuseaddr_conflict: add missing new line at the end of the output
Date: Thu, 11 Apr 2024 11:55:48 +0200
Message-ID: <20240411095423.328923096@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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


