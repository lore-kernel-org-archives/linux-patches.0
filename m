Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034C73F39D1;
	Wed, 20 May 2026 17:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299328; cv=none; b=p/IXDm2oEMzg5gnfUmocdnFLgbjtZRmQnnyIosIvMyPmKHXpI/+pemrk8fSd4AMGaBxSeB0KEFHJDANywTZ4MfX5eUcqd0Ul7ZbmU3VTy1XTHVcR/lmQAcz1T3OGaPS50XYFEHbiNwksb0X3eGzcfRW5nfcTodWt7ADcvLVXnc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299328; c=relaxed/simple;
	bh=wPRBpL0aElTlv2WPQnN/2bUPG9Q0UDUn86Heo4Lsyuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lP83RMMHEB/QyfSWZUfg90TSInnDUCMj9mDI4b5No76LhhwhgkPFUa3hHx9qDiDvJWYTOeSF5JEBI0XTWFpK2myGymW24SG1UxOT8QeWU0mWlMDcpXyxjUxCsV5rBuSB3bb0mAfm6R7KbjrCM7cAs33dwozEyWRtU8EJJIP8e1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1uliDeo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1uliDeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E091F000E9;
	Wed, 20 May 2026 17:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299326;
	bh=Xs+ZP/f2mPIWOsoQQDBXzqo7K1+PQjrpdBRNQ21dQAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1uliDeokNCltgl3qY5fp0HgTKD9FLt5218Ml3DSmxzgdZK2MCrh5x4XmL2hV8+bG
	 nimIVIMtAoNwxvzRTLWUg6f4lWydiJeaKAPo98vAbkKPnHFT3L8qqGXwy83oJEkBt3
	 iPyq/geSq0038HIyZQdnFijT80mpOaKROJ8S6rgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 730/957] tools/power turbostat: Fix unrecognized option -P
Date: Wed, 20 May 2026 18:20:13 +0200
Message-ID: <20260520162150.386590408@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Arcari <darcari@redhat.com>

[ Upstream commit ce012c966b518c53475ba9a4e979242d7322d819 ]

The '-P' short option (shorthand for --no-perf) is not present in the
optstring of the second call to getopt_long_only(). This results in
the "unrecognized option" error when the tool reaches the main parsing
loop.

Add 'P' to the second getopt_long_only() call to ensure it is
consistently recognized.

Fixes: a0e86c90b83c ("tools/power turbostat: Add --no-perf option")
Signed-off-by: David Arcari <darcari@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index ec4b7ff8810b1..313872f64a9a9 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -11054,7 +11054,7 @@ void cmdline(int argc, char **argv)
 	}
 	optind = 0;
 
-	while ((opt = getopt_long_only(argc, argv, "+C:c:Dde:hi:Jn:N:o:qMST:v", long_options, &option_index)) != -1) {
+	while ((opt = getopt_long_only(argc, argv, "+C:c:Dde:hi:Jn:N:o:qMPST:v", long_options, &option_index)) != -1) {
 		switch (opt) {
 		case 'a':
 			parse_add_command(optarg);
-- 
2.53.0



