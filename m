Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B73258F
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD288C433EF;
	Thu, 23 Feb 2023 13:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157972;
	bh=/oHX/FS3261RrazsFaq9IF48263e4WS1cQHL6mlQeuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/pPuw5NI9mKHWOrmovvPORhOfRDFkry+gkfZ8e6KHzb/OP3ZR/3QJwA3/9NT3mv3
	 3c12kl7ksEgw6UJ5oQwi9n8e3kYFNHHSizkf8Q49lxUKMJMYxv5exNIu7sRGUr7BIG
	 De5Jp3+8LD6CPzJWcamxdtJa8wUNTLL/nvhEHb9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Matthias Maennich <maennich@google.com>
Subject: [PATCH 5.15 33/36] scripts/pahole-flags.sh: Use pahole-version.sh
Date: Thu, 23 Feb 2023 14:07:09 +0100
Message-Id: <20230223130430.571823567@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

commit 2d6c9810eb8915c4ddede707b8e167a1d919e1ca upstream.

Use pahole-version.sh to get pahole's version code to reduce the amount
of duplication across the tree.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220201205624.652313-4-nathan@kernel.org
Signed-off-by: Matthias Maennich <maennich@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/pahole-flags.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/pahole-flags.sh
+++ b/scripts/pahole-flags.sh
@@ -7,7 +7,7 @@ if ! [ -x "$(command -v ${PAHOLE})" ]; t
 	exit 0
 fi
 
-pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
+pahole_ver=$($(dirname $0)/pahole-version.sh ${PAHOLE})
 
 if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
 	# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars


