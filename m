Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6976D35A95A;
	Wed,  3 Dec 2025 16:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778920; cv=none; b=EYcacrJi7bUXjW+1js70ky6JEYH1AnSlSrA9JAxnehYzy+i7+xK0cprWRyUSIXHTFgXaulNSmNJuM7kUWlC/Ml3mC/OzkuZdhbLss0ttn2V8+yGmTS34sAZh3nMrnEj1hZ7yT6vVQKJte/M93TueWqD6+RQCYB1B16YAB2sYKck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778920; c=relaxed/simple;
	bh=2FTYSJa8wDTomDowoiIPfztaPPAs2/kyNbnnDU1OE5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C7gQdtDbc4QT281htQz0ind+j/fGx97fNAEWJmbGzALYWJmi6VJDPBVYz8tffqGe8EhfFukpfqaTJjZsdACRrSqfVqsrCY3cPxcn8O74sv9sYEpaKE0yg31Orkf8yHLq7FFZQF0GpIeVxFSD3YGrGTwxKGMQIp5USQy5ixC3Hng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Bd3ugMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Bd3ugMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46F5C4CEF5;
	Wed,  3 Dec 2025 16:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778920;
	bh=2FTYSJa8wDTomDowoiIPfztaPPAs2/kyNbnnDU1OE5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Bd3ugMv8lPyPK18IrCft9FPNeciiTFS6nwfPQclbgoj5Ko9M7j1vo92zwKqEVzzA
	 NfpXaj2bK/8ugludZh/1bHq4XGPt7Fp9j9HBTluDOokqPZeR/Mw+rEBU2pvDniLO/i
	 Ou2U5DLzarL+TDKDpiqmZQk3+p0Ar/abh5Mewdyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/568] selftests/bpf: Upon failures, exit with code 1 in test_xsk.sh
Date: Wed,  3 Dec 2025 16:21:41 +0100
Message-ID: <20251203152444.365223178@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit 2a912258c90e895363c0ffc0be8a47f112ab67b7 ]

Currently, even if some subtests fails, the end result will still yield
"ok 1 selftests: bpf: test_xsk.sh". Fix it by exiting with 1 if there are
any failures.

Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20250828-selftests-bpf-test_xsk_ret-v1-1-e6656c01f397@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_xsk.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 4e3ec38cbe68c..09788b847e89b 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -206,4 +206,6 @@ done
 
 if [ $failures -eq 0 ]; then
         echo "All tests successful!"
+else
+	exit 1
 fi
-- 
2.51.0



