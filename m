Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD32F4C73
	for <patches@lists.linux.dev>; Fri, 13 May 2022 19:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=7AQ1tnmhdj6GIYIC2jyaasQB2WbOtM0epCQajREwxjk=; b=SCCmofz3S3HUQcBWMURDzrOQWY
	GByb02Xi3RCgjqfZC/HDw6IJuRFVfxzvoLe2RTYOI9S6uknoOv/r8y5/nCeDTV/jDFdYo4ieAOxGn
	ikha2qhXoeDeMmlI0DvnatYzcang7YQcyWbeVWIDfDv6iiyFXZrmP0UzLYgPbBh9QM2Z4TOoIJYXK
	/cShfIxHCHcsjreGCVX0yJM/tpEowzBD3ifmSg7pL4FDPCBj4c0MINTOTXl3ees1VngzhXWlBrOan
	uHFZrzAL7/hZYI0W4PjY6QjsMwK+BdEIEfMOLBIU4GLQQM3XGuvf+fkH5z2vSleSb539JAy7Sbqyu
	VXXoX4+w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1npb7T-00HM1v-Cn; Fri, 13 May 2022 19:38:35 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org
Cc: patches@lists.linux.dev,
	amir73il@gmail.com,
	pankydev8@gmail.com,
	tytso@mit.edu,
	josef@toxicpanda.com,
	jmeneghi@redhat.com,
	jake@lwn.net,
	mcgrof@kernel.org
Subject: [PATCH 0/4] kdevops: use linux-kdevops for the main tree
Date: Fri, 13 May 2022 12:38:27 -0700
Message-Id: <20220513193831.4136212-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

More just like a heads up as to the next steps from discussions at
LSFMM with regards to kdevops. Those using kdevops in some environemnts
will want to read the last commit.

This work starts off by making the linux-kdevops organization the default
for the source of commits for the kdevops projects. We can now share
efforts, and commits. The last commit will contain more details as
to the motivation for this.

Luis Chamberlain (4):
  workflows/Kconfig: be consistent when enabling fstests or blktests
  kdevops: move generic kdevops variables to its own file
  playbooks: add a common playbook a git reset task for kdevops
  kdevops: make linux-kdevops the default tree

 kconfigs/workflows/Kconfig               |  6 ++++
 kconfigs/workflows/Kconfig.shared        |  2 +-
 playbooks/common.yml                     |  4 +++
 playbooks/roles/common/README.md         | 38 ++++++++++++++++++++
 playbooks/roles/common/defaults/main.yml |  7 ++++
 playbooks/roles/common/tasks/main.yml    | 23 ++++++++++++
 workflows/Makefile                       | 33 +----------------
 workflows/common/Makefile                | 46 ++++++++++++++++++++++++
 8 files changed, 126 insertions(+), 33 deletions(-)
 create mode 100644 playbooks/common.yml
 create mode 100644 playbooks/roles/common/README.md
 create mode 100644 playbooks/roles/common/defaults/main.yml
 create mode 100644 playbooks/roles/common/tasks/main.yml
 create mode 100644 workflows/common/Makefile

-- 
2.35.1

