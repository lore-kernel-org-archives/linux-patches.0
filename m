Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600E22236FC;
	Mon,  2 Jun 2025 14:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873562; cv=none; b=WqKzz9WiRdHyeUhIZ6JSU45lo+Qwt868a347zd15aeFZvrvXnT6KNrAJNVpnWvV8TAiB853DuZx5i2EfvsM7vGKqFlAwja79qKXLokXZEBuLyF01dPArGFyyzlYTosoLHaI9HdGjnnYwPJKGg0s9f7n2th4uqEconveNQW9A6ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873562; c=relaxed/simple;
	bh=CrnsF92GaWZd9jdxxHHt8TNVR3RfsUJg7uDqnFN/XoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPvfEm5lLYcbHTZXYaP4uaIRfapyjW84Hwl/MXcaW5nsmQj3pFKUwGdC96Q9IiIxR18gWjMyN6kcoJXlVmPVyf7TzoZ6vfEVLHdxNP9NOvsdA7aupdV9EbdJi+LL4gsc1ttRuUf2bV5zADitqaX6ItgqtRq/DTw3wMuiGZmeKkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imjnklvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imjnklvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2689C4CEEB;
	Mon,  2 Jun 2025 14:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873562;
	bh=CrnsF92GaWZd9jdxxHHt8TNVR3RfsUJg7uDqnFN/XoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imjnklvOeJ/t4TS53Adv97ufcpVnDnPdwZ3EFRqSrqF0Ollq+lKbi+ABEw4GRHJOD
	 Ihx+BoUC0uTX9vsw5pTNis2jAR4hY8JmH7//Vbz9UIGo270lDsoz7hLpiy7L2IABwW
	 a0T1icVYHBShakgeCH/IB1qCOySeu8rJH1/8gu3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Krakauer <krakauer@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/444] selftests/net: have `gro.sh -t` return a correct exit code
Date: Mon,  2 Jun 2025 15:43:57 +0200
Message-ID: <20250602134347.920618815@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kevin Krakauer <krakauer@google.com>

[ Upstream commit 784e6abd99f24024a8998b5916795f0bec9d2fd9 ]

Modify gro.sh to return a useful exit code when the -t flag is used. It
formerly returned 0 no matter what.

Tested: Ran `gro.sh -t large` and verified that test failures return 1.
Signed-off-by: Kevin Krakauer <krakauer@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250226192725.621969-2-krakauer@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/gro.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/gro.sh b/tools/testing/selftests/net/gro.sh
index 342ad27f631b1..e771f5f7faa26 100755
--- a/tools/testing/selftests/net/gro.sh
+++ b/tools/testing/selftests/net/gro.sh
@@ -95,5 +95,6 @@ trap cleanup EXIT
 if [[ "${test}" == "all" ]]; then
   run_all_tests
 else
-  run_test "${proto}" "${test}"
+  exit_code=$(run_test "${proto}" "${test}")
+  exit $exit_code
 fi;
-- 
2.39.5



