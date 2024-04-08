Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C75E79F0;
	Mon,  8 Apr 2024 13:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582930; cv=none; b=i+ngdG2HrOUYKDy2dQg/8zijULvU7Q+B1esBiw0G7XonpAGGEvBd0S3PaGIjOdKPd7mGBZ4TCqw3UXksI/fxcj5c4qRGlna6qO4Acm9/wU9yup84Ww9Kd1dHd8YUQVmj5886grie9FJfkAL71yJvmEOS5KVHEueK2OWQmeVEMEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582930; c=relaxed/simple;
	bh=ReEdpTZw9NAYumSf1vvZi3fEp2bhsKceNuiztHJfzkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVc9a0dxzdPxlkf1TvgXaOeGNMyuy/AwbGTFdfMmyZb2RCa14vKQdouZ5Tgs2SrzBgd6nNVhsjqyfgEhrSRACDi5E/ZR5fHV5dRUsebjO48KP0cHqEPs/ANvArZJm4SVItBbdGAI6OUN5HlfuuA+21p243EEQhRYNT4NSQNCtBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfPRmubi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfPRmubi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894DFC433C7;
	Mon,  8 Apr 2024 13:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582929;
	bh=ReEdpTZw9NAYumSf1vvZi3fEp2bhsKceNuiztHJfzkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfPRmubi7CkZ6uEcanFLaLmo/oNCExCHi7WIsx0oe/WYmXb51dI03vYlvSSqq0Fdg
	 UUB6flnTBbkURmS9fZhS7cBFD0VIETs9l1cyL6MOknKSXH1mDNplEQo0HpVVN6UYUJ
	 7XL/gL5J+x94K3yLNnTIk4+DWZWu7BIDa0x6H8eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 117/252] selftests: reuseaddr_conflict: add missing new line at the end of the output
Date: Mon,  8 Apr 2024 14:56:56 +0200
Message-ID: <20240408125310.261921977@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


