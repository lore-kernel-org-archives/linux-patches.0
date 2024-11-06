Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF84D1DEFF4;
	Wed,  6 Nov 2024 12:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894830; cv=none; b=jvdKVMLsm3aRItmZypoVBrAj0C/hPciNoNWbUmit94al8nuN27IECYPzfNcj9sAoTC7WekAxQrHHslSpKM/NLNH7VD+y8rMSGCaK648qM91Fp/LegX/shoOKr+jHdguAyNz1Kt1yMsLCFS2SJqexzG1IBwa078XM5D/yVmLlq8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894830; c=relaxed/simple;
	bh=gceh0QWRT+7kKBZmo9BRT66o8QAeo8JyB5H7pTQ0hlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYqosNTIG6cjuOHBsKmD6QhfXuXyNArzBkT1mNLxv25YJ9MwBWkqj2ILQMguHW8MXzK16h79jYWzT7yr13hxgigtA/tduusMg71lnJxT7ASOPlGcpiP77Q2Nlegqk5IDhXC2G+5YKlPF9euEuv6LG+3dBvfHIw+Bij7EshrFVqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYjpmZaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYjpmZaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F24C4CECD;
	Wed,  6 Nov 2024 12:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894830;
	bh=gceh0QWRT+7kKBZmo9BRT66o8QAeo8JyB5H7pTQ0hlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYjpmZazHKHwRhnCnnpmpbf66OVJvUidNVwa/WC6I/C7vREYJDr5wp7rdIPxvgIZr
	 BDC+KGhaNOF+PC9ru7zv+BxOJ2g6Rb/3LyIGchUnTEaikW3b2ptNhwNIc5mJxxOet8
	 T+UuTLkJ9TJ8D0uZqwD6r5epZtwHwxAxnaMv4DzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Roxell <anders.roxell@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/350] scripts: kconfig: merge_config: config files: add a trailing newline
Date: Wed,  6 Nov 2024 12:58:55 +0100
Message-ID: <20241106120321.050849521@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

From: Anders Roxell <anders.roxell@linaro.org>

[ Upstream commit 33330bcf031818e60a816db0cfd3add9eecc3b28 ]

When merging files without trailing newlines at the end of the file, two
config fragments end up at the same row if file1.config doens't have a
trailing newline at the end of the file.

file1.config "CONFIG_1=y"
file2.config "CONFIG_2=y"
./scripts/kconfig/merge_config.sh -m .config file1.config file2.config

This will generate a .config looking like this.
cat .config
...
CONFIG_1=yCONFIG_2=y"

Making sure so we add a newline at the end of every config file that is
passed into the script.

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/merge_config.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
index 67d131447631..6b918882d32c 100755
--- a/scripts/kconfig/merge_config.sh
+++ b/scripts/kconfig/merge_config.sh
@@ -128,6 +128,8 @@ for MERGE_FILE in $MERGE_LIST ; do
 		fi
 		sed -i "/$CFG[ =]/d" $TMP_FILE
 	done
+	# In case the previous file lacks a new line at the end
+	echo >> $TMP_FILE
 	cat $MERGE_FILE >> $TMP_FILE
 done
 
-- 
2.43.0



