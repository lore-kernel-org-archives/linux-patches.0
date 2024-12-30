Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E37615E8B;
	Mon, 30 Dec 2024 15:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573959; cv=none; b=LYfrmioBFUUjGcR459+alh4d80HLpbsp2qbHGiBpSv3e4nL6UY+1K6r+Xh23QJQZZT4WcFcOXqn+hcSqbpCVylHs80tKyTc8ZH1sWDJ2QT0Z+esXbiT/QCsc4ijvWIh4pQVisk9WHd2NnmHmHlg/bcKcPiq/p3d7PT8PcRX+x1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573959; c=relaxed/simple;
	bh=zGsTsaj7iYPNfHkV1S91MaTpr0lo8iW5VMif3vRWmRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3CdUbDEd58IEjpqiMC1LQMzXIQXag6agbV031vjG2bR3lLO9qJtKUiVJeu++JdAWzlNLx2wN4gf1VAHk14zFSUupkHqHYUIkNLKDLLToA3jIfhVWmF2xsA3kh7fp4SExGCaUUPEw0zyQTsZaM6CwRS+WBHAZfrory10AR5xCzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGU+E8Dr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGU+E8Dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9DFC4CED0;
	Mon, 30 Dec 2024 15:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573959;
	bh=zGsTsaj7iYPNfHkV1S91MaTpr0lo8iW5VMif3vRWmRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGU+E8DrT9og+QV6G0tssB3wdmzMNV6MSYjh/MCEuYvUbseMHXIciRgX3WVLpy5l+
	 J6+PY+VYXZxWQhqkoEXaLJ0xy9FFMz3l/TkmDt9Z7D+jGM4hVYA0gg4p3K4nH3xymv
	 QR5GAZry0oiOquGEt8c/WVqICrcBZWGpE9YCS9/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 6.6 84/86] x86/cpu/intel: Drop stray FAM6 check with new Intel CPU model defines
Date: Mon, 30 Dec 2024 16:43:32 +0100
Message-ID: <20241230154214.902963889@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

From: Andrew Cooper <andrew.cooper3@citrix.com>

commit 34b3fc558b537bdf99644dcde539e151716f6331 upstream.

The outer if () should have been dropped when switching to c->x86_vfm.

Fixes: 6568fc18c2f6 ("x86/cpu/intel: Switch to new Intel CPU model defines")
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20240529183605.17520-1-andrew.cooper3@citrix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/intel.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -341,17 +341,13 @@ static void early_init_intel(struct cpui
 	}
 
 	/* Penwell and Cloverview have the TSC which doesn't sleep on S3 */
-	if (c->x86 == 6) {
-		switch (c->x86_vfm) {
-		case INTEL_ATOM_SALTWELL_MID:
-		case INTEL_ATOM_SALTWELL_TABLET:
-		case INTEL_ATOM_SILVERMONT_MID:
-		case INTEL_ATOM_AIRMONT_NP:
-			set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC_S3);
-			break;
-		default:
-			break;
-		}
+	switch (c->x86_vfm) {
+	case INTEL_ATOM_SALTWELL_MID:
+	case INTEL_ATOM_SALTWELL_TABLET:
+	case INTEL_ATOM_SILVERMONT_MID:
+	case INTEL_ATOM_AIRMONT_NP:
+		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC_S3);
+		break;
 	}
 
 	/*


